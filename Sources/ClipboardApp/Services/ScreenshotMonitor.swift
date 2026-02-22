import AppKit
import Foundation

@MainActor
final class ScreenshotMonitor {
    private let desktopURL: URL
    private let pollInterval: TimeInterval
    private let isEnabled: () -> Bool
    private let onScreenshotDetected: (Data) -> Void

    private var timer: Timer?
    private var lastProcessedDate: Date

    init(
        desktopURL: URL = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop", isDirectory: true),
        pollInterval: TimeInterval = 1.2,
        isEnabled: @escaping () -> Bool,
        onScreenshotDetected: @escaping (Data) -> Void
    ) {
        self.desktopURL = desktopURL
        self.pollInterval = pollInterval
        self.isEnabled = isEnabled
        self.onScreenshotDetected = onScreenshotDetected
        self.lastProcessedDate = Date()
    }

    func start() {
        guard timer == nil else { return }

        lastProcessedDate = max(lastProcessedDate, latestScreenshotDate() ?? lastProcessedDate)
        timer = Timer.scheduledTimer(withTimeInterval: pollInterval, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                self.poll()
            }
        }

        if let timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    private func poll() {
        guard isEnabled() else { return }

        guard let screenshot = latestScreenshot(after: lastProcessedDate) else { return }
        lastProcessedDate = screenshot.modifiedAt

        guard
            let image = NSImage(contentsOf: screenshot.url),
            let pngData = image.toPNGData(),
            pngData.isEmpty == false
        else {
            return
        }

        onScreenshotDetected(pngData)
    }

    private func latestScreenshotDate() -> Date? {
        latestScreenshot(after: .distantPast)?.modifiedAt
    }

    private func latestScreenshot(after date: Date) -> (url: URL, modifiedAt: Date)? {
        guard
            let fileURLs = try? FileManager.default.contentsOfDirectory(
                at: desktopURL,
                includingPropertiesForKeys: [.contentModificationDateKey, .isRegularFileKey],
                options: [.skipsHiddenFiles]
            )
        else {
            return nil
        }

        var candidate: (URL, Date)?

        for url in fileURLs {
            guard isScreenshotFile(url) else { continue }

            guard
                let values = try? url.resourceValues(forKeys: [.contentModificationDateKey, .isRegularFileKey]),
                values.isRegularFile == true,
                let modifiedAt = values.contentModificationDate,
                modifiedAt > date
            else {
                continue
            }

            if let current = candidate {
                if modifiedAt > current.1 {
                    candidate = (url, modifiedAt)
                }
            } else {
                candidate = (url, modifiedAt)
            }
        }

        if let candidate {
            return (url: candidate.0, modifiedAt: candidate.1)
        }

        return nil
    }

    private func isScreenshotFile(_ url: URL) -> Bool {
        let fileName = url.lastPathComponent.lowercased()
        let isImage = fileName.hasSuffix(".png") || fileName.hasSuffix(".jpg") || fileName.hasSuffix(".jpeg")
        guard isImage else { return false }

        return fileName.contains("screenshot") || fileName.contains("screen shot") || fileName.contains("스크린샷")
    }
}
