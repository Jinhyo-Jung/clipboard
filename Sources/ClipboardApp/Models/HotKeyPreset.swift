import Carbon.HIToolbox
import Foundation

struct HotKeyPreset: Identifiable, Equatable {
    let id: String
    let title: String
    let keyCode: UInt32
    let carbonModifiers: UInt32

    static let presets: [HotKeyPreset] = [
        HotKeyPreset(
            id: "ctrl_option_v",
            title: "⌃⌥V (추천)",
            keyCode: UInt32(kVK_ANSI_V),
            carbonModifiers: UInt32(controlKey | optionKey)
        ),
        HotKeyPreset(
            id: "ctrl_shift_v",
            title: "⌃⇧V",
            keyCode: UInt32(kVK_ANSI_V),
            carbonModifiers: UInt32(controlKey | shiftKey)
        ),
        HotKeyPreset(
            id: "cmd_option_v",
            title: "⌘⌥V",
            keyCode: UInt32(kVK_ANSI_V),
            carbonModifiers: UInt32(cmdKey | optionKey)
        )
    ]

    static var fallback: HotKeyPreset {
        presets[0]
    }

    static func from(id: String) -> HotKeyPreset {
        presets.first { $0.id == id } ?? fallback
    }
}
