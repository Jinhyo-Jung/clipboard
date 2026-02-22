import AppKit
import ApplicationServices
import Foundation
import Darwin

enum PasteResult {
    case success
    case accessibilityDenied
    case eventCreationFailed
}

enum PasteService {
    static func paste(text: String, targetApplication: NSRunningApplication?) -> PasteResult {
        copyToPasteboard(text)

        guard AXIsProcessTrusted() else {
            _ = requestAccessibilityPermission()
            return .accessibilityDenied
        }

        activateTargetApp(targetApplication)

        guard emitCommandV() else {
            return .eventCreationFailed
        }

        return .success
    }

    static func requestAccessibilityPermission() -> Bool {
        let options = [
            "AXTrustedCheckOptionPrompt": true
        ] as CFDictionary

        return AXIsProcessTrustedWithOptions(options)
    }

    static func openAccessibilitySettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility") else {
            return
        }

        NSWorkspace.shared.open(url)
    }

    private static func copyToPasteboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }

    private static func activateTargetApp(_ app: NSRunningApplication?) {
        guard let app else { return }
        _ = app.activate(options: [.activateIgnoringOtherApps])
        usleep(140_000)
    }

    private static func emitCommandV() -> Bool {
        guard
            let source = CGEventSource(stateID: .combinedSessionState),
            let commandDown = CGEvent(keyboardEventSource: source, virtualKey: 55, keyDown: true),
            let vDown = CGEvent(keyboardEventSource: source, virtualKey: 9, keyDown: true),
            let vUp = CGEvent(keyboardEventSource: source, virtualKey: 9, keyDown: false),
            let commandUp = CGEvent(keyboardEventSource: source, virtualKey: 55, keyDown: false)
        else {
            return false
        }

        vDown.flags = .maskCommand
        vUp.flags = .maskCommand

        let tapLocation: CGEventTapLocation = .cgAnnotatedSessionEventTap
        commandDown.post(tap: tapLocation)
        vDown.post(tap: tapLocation)
        vUp.post(tap: tapLocation)
        commandUp.post(tap: tapLocation)

        return true
    }
}
