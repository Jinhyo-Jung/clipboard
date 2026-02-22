import Combine
import Foundation

@MainActor
final class SettingsStore: ObservableObject {
    @Published var maxItems: Int {
        didSet {
            maxItems = Self.allowedMaxItems.contains(maxItems) ? maxItems : 100
            defaults.set(maxItems, forKey: Keys.maxItems)
        }
    }

    @Published var isCapturePaused: Bool {
        didSet {
            defaults.set(isCapturePaused, forKey: Keys.isCapturePaused)
        }
    }

    @Published var launchAtLogin: Bool {
        didSet {
            defaults.set(launchAtLogin, forKey: Keys.launchAtLogin)
        }
    }

    @Published var autoCaptureScreenshotToClipboard: Bool {
        didSet {
            defaults.set(autoCaptureScreenshotToClipboard, forKey: Keys.autoCaptureScreenshotToClipboard)
        }
    }

    @Published var hotKeyPresetID: String {
        didSet {
            defaults.set(hotKeyPresetID, forKey: Keys.hotKeyPresetID)
        }
    }

    var hotKeyPreset: HotKeyPreset {
        HotKeyPreset.from(id: hotKeyPresetID)
    }

    private let defaults: UserDefaults

    static let allowedMaxItems = [50, 100, 200]

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults

        let storedMaxItems = defaults.integer(forKey: Keys.maxItems)
        self.maxItems = Self.allowedMaxItems.contains(storedMaxItems) ? storedMaxItems : 100
        self.isCapturePaused = defaults.bool(forKey: Keys.isCapturePaused)
        self.launchAtLogin = defaults.bool(forKey: Keys.launchAtLogin)
        if defaults.object(forKey: Keys.autoCaptureScreenshotToClipboard) == nil {
            self.autoCaptureScreenshotToClipboard = true
        } else {
            self.autoCaptureScreenshotToClipboard = defaults.bool(forKey: Keys.autoCaptureScreenshotToClipboard)
        }

        if let presetID = defaults.string(forKey: Keys.hotKeyPresetID) {
            self.hotKeyPresetID = HotKeyPreset.from(id: presetID).id
        } else {
            self.hotKeyPresetID = HotKeyPreset.fallback.id
        }
    }

    private enum Keys {
        static let maxItems = "settings.maxItems"
        static let isCapturePaused = "settings.isCapturePaused"
        static let launchAtLogin = "settings.launchAtLogin"
        static let autoCaptureScreenshotToClipboard = "settings.autoCaptureScreenshotToClipboard"
        static let hotKeyPresetID = "settings.hotKeyPresetID"
    }
}
