import AppKit
import SwiftUI

@main
struct ClipboardAppMain: App {
    @StateObject private var controller = ClipboardAppController()

    init() {
        NSApplication.shared.setActivationPolicy(.accessory)
    }

    var body: some Scene {
        MenuBarExtra {
            MenuBarMenuView(controller: controller)
        } label: {
            Label(
                "Clipboard",
                systemImage: controller.settings.isCapturePaused ? "pause.circle" : "clipboard"
            )
        }

        Settings {
            SettingsView(controller: controller)
        }
    }
}
