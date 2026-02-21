import AppKit
import Foundation

@MainActor
final class ClipboardMonitor {
    private let pasteboard: NSPasteboard
    private let pollInterval: TimeInterval
    private let isPaused: () -> Bool
    private let onTextCaptured: (String) -> Void

    private var timer: Timer?
    private var lastChangeCount: Int

    init(
        pasteboard: NSPasteboard = .general,
        pollInterval: TimeInterval = 0.35,
        isPaused: @escaping () -> Bool,
        onTextCaptured: @escaping (String) -> Void
    ) {
        self.pasteboard = pasteboard
        self.pollInterval = pollInterval
        self.isPaused = isPaused
        self.onTextCaptured = onTextCaptured
        self.lastChangeCount = pasteboard.changeCount
    }

    func start() {
        guard timer == nil else { return }

        lastChangeCount = pasteboard.changeCount
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
        guard isPaused() == false else { return }

        let currentCount = pasteboard.changeCount
        guard currentCount != lastChangeCount else { return }
        lastChangeCount = currentCount

        guard let text = pasteboard.string(forType: .string) else { return }
        onTextCaptured(text)
    }
}
