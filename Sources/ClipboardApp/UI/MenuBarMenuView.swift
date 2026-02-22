import AppKit
import SwiftUI

struct MenuBarMenuView: View {
    @ObservedObject var controller: ClipboardAppController

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button("히스토리 패널 열기 (\u{2303}\u{2325}V)") {
                controller.openPanel()
            }

            Button(controller.settings.isCapturePaused ? "클립 기록 재개" : "클립 기록 일시 중지") {
                controller.setCapturePaused(!controller.settings.isCapturePaused)
            }

            Button(controller.settings.autoCaptureScreenshotToClipboard ? "스크린샷 자동 저장 끄기" : "스크린샷 자동 저장 켜기") {
                controller.setAutoCaptureScreenshotToClipboard(!controller.settings.autoCaptureScreenshotToClipboard)
            }

            Menu("최대 저장 개수") {
                ForEach(SettingsStore.allowedMaxItems, id: \.self) { itemCount in
                    Button(maxItemLabel(itemCount)) {
                        controller.setMaxItems(itemCount)
                    }
                }
            }

            Menu("전역 단축키") {
                ForEach(HotKeyPreset.presets) { preset in
                    Button(hotKeyLabel(preset)) {
                        controller.setHotKeyPreset(id: preset.id)
                    }
                }
            }

            Button("히스토리 전체 삭제 (\u{21E7}\u{2318}\u{232B})", role: .destructive) {
                controller.clearAll()
            }

            Divider()

            Button("설정 열기") {
                controller.openSettingsWindow()
            }

            Button("접근성 설정 열기") {
                PasteService.openAccessibilitySettings()
            }

            if let infoMessage = controller.infoMessage {
                Divider()
                Text(infoMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let errorMessage = controller.errorMessage {
                Divider()
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            Divider()

            Button("종료") {
                NSApp.terminate(nil)
            }
        }
        .padding(.vertical, 4)
        .frame(minWidth: 320)
    }

    private func maxItemLabel(_ value: Int) -> String {
        let selected = controller.settings.maxItems == value ? "✓ " : ""
        return "\(selected)\(value)개"
    }

    private func hotKeyLabel(_ preset: HotKeyPreset) -> String {
        let selected = controller.settings.hotKeyPresetID == preset.id ? "✓ " : ""
        return "\(selected)\(preset.title)"
    }
}
