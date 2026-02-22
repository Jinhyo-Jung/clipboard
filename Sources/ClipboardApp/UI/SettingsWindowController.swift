import AppKit
import SwiftUI

@MainActor
final class SettingsWindowController: NSObject, NSWindowDelegate {
    private var window: NSWindow?

    func show(controller: ClipboardAppController) {
        if window == nil {
            createWindow(controller: controller)
        }

        guard let window else { return }

        if let hostingController = window.contentViewController as? NSHostingController<SettingsView> {
            hostingController.rootView = SettingsView(controller: controller)
        }

        NSApplication.shared.activate(ignoringOtherApps: true)
        window.makeKeyAndOrderFront(nil)
    }

    private func createWindow(controller: ClipboardAppController) {
        let hostingController = NSHostingController(rootView: SettingsView(controller: controller))

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 520, height: 360),
            styleMask: [.titled, .closable, .miniaturizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Clipboard 설정"
        window.isReleasedWhenClosed = false
        window.center()
        window.contentViewController = hostingController
        window.delegate = self

        self.window = window
    }

    func windowWillClose(_ notification: Notification) {
        // 윈도우 인스턴스를 유지해 다음 오픈을 빠르게 처리한다.
    }
}
