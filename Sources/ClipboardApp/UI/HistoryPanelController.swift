import AppKit
import SwiftUI

@MainActor
final class HistoryPanelController: NSObject, NSWindowDelegate {
    var onDidClose: (() -> Void)?

    private var panel: NSPanel?
    private var hostingView: NSHostingView<HistoryPanelView>?

    func show(controller: ClipboardAppController) {
        if panel == nil {
            createPanel(controller: controller)
        }

        hostingView?.rootView = HistoryPanelView(
            controller: controller,
            sessionID: controller.panelSessionID,
            onClose: { [weak self] in
                self?.close()
            }
        )

        guard let panel else { return }

        restorePanelPositionIfNeeded(panel)
        NSApplication.shared.activate(ignoringOtherApps: true)
        panel.makeKeyAndOrderFront(nil)
    }

    func close() {
        guard let panel else { return }
        panel.orderOut(nil)
        onDidClose?()
    }

    func windowDidMove(_ notification: Notification) {
        guard let frame = panel?.frame else { return }

        UserDefaults.standard.set(frame.origin.x, forKey: Keys.lastPanelOriginX)
        UserDefaults.standard.set(frame.origin.y, forKey: Keys.lastPanelOriginY)
    }

    func windowDidResignKey(_ notification: Notification) {
        close()
    }

    private func createPanel(controller: ClipboardAppController) {
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 620, height: 420),
            styleMask: [.titled, .closable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.isMovableByWindowBackground = true
        panel.delegate = self

        let rootView = HistoryPanelView(
            controller: controller,
            sessionID: controller.panelSessionID,
            onClose: { [weak self] in
                self?.close()
            }
        )
        let hostingView = NSHostingView(rootView: rootView)

        panel.contentView = hostingView

        self.panel = panel
        self.hostingView = hostingView
    }

    private func restorePanelPositionIfNeeded(_ panel: NSPanel) {
        let defaults = UserDefaults.standard

        if
            defaults.object(forKey: Keys.lastPanelOriginX) != nil,
            defaults.object(forKey: Keys.lastPanelOriginY) != nil
        {
            let x = defaults.double(forKey: Keys.lastPanelOriginX)
            let y = defaults.double(forKey: Keys.lastPanelOriginY)
            panel.setFrameOrigin(NSPoint(x: x, y: y))
        } else {
            panel.center()
        }
    }

    private enum Keys {
        static let lastPanelOriginX = "panel.lastOriginX"
        static let lastPanelOriginY = "panel.lastOriginY"
    }
}
