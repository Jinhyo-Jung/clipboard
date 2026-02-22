import SwiftUI

struct SettingsView: View {
    @ObservedObject var controller: ClipboardAppController

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Clipboard 설정")
                .font(.title3)
                .bold()

            HStack {
                Text("최대 저장 개수")
                Picker("최대 저장 개수", selection: maxItemsBinding) {
                    ForEach(SettingsStore.allowedMaxItems, id: \.self) { value in
                        Text("\(value)개").tag(value)
                    }
                }
                .pickerStyle(.segmented)
            }

            HStack {
                Text("전역 단축키")
                Picker("전역 단축키", selection: hotKeyBinding) {
                    ForEach(HotKeyPreset.presets) { preset in
                        Text(preset.title).tag(preset.id)
                    }
                }
                .frame(width: 220)
            }

            Toggle("클립 기록 일시 중지", isOn: pausedBinding)
            Toggle("시작 시 자동 실행", isOn: launchAtLoginBinding)
            Toggle("스크린샷 자동 클립보드 저장 (⌘⇧5)", isOn: screenshotCaptureBinding)

            HStack(spacing: 12) {
                Button("접근성 권한 요청") {
                    controller.requestAccessibilityPermissionFromSettings()
                }

                Button("시스템 설정 열기") {
                    PasteService.openAccessibilitySettings()
                }
            }

            if let infoMessage = controller.infoMessage {
                Text(infoMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let errorMessage = controller.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
            }

            Spacer()
        }
        .padding(20)
        .frame(width: 540, height: 360)
    }

    private var maxItemsBinding: Binding<Int> {
        Binding(
            get: { controller.settings.maxItems },
            set: { controller.setMaxItems($0) }
        )
    }

    private var hotKeyBinding: Binding<String> {
        Binding(
            get: { controller.settings.hotKeyPresetID },
            set: { controller.setHotKeyPreset(id: $0) }
        )
    }

    private var pausedBinding: Binding<Bool> {
        Binding(
            get: { controller.settings.isCapturePaused },
            set: { controller.setCapturePaused($0) }
        )
    }

    private var launchAtLoginBinding: Binding<Bool> {
        Binding(
            get: { controller.settings.launchAtLogin },
            set: { controller.setLaunchAtLogin($0) }
        )
    }

    private var screenshotCaptureBinding: Binding<Bool> {
        Binding(
            get: { controller.settings.autoCaptureScreenshotToClipboard },
            set: { controller.setAutoCaptureScreenshotToClipboard($0) }
        )
    }
}
