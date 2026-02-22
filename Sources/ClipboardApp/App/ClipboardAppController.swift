import Combine
import AppKit
import Foundation

@MainActor
final class ClipboardAppController: ObservableObject {
    @Published private(set) var items: [ClipboardItem] = []
    @Published private(set) var panelSessionID = UUID()
    @Published private(set) var isPanelVisible = false
    @Published var infoMessage: String?
    @Published var errorMessage: String?

    let settings: SettingsStore

    private let historyStore: ClipboardHistoryStore
    private let monitor: ClipboardMonitor
    private let screenshotMonitor: ScreenshotMonitor
    private let hotKeyManager = GlobalHotKeyManager()
    private let panelController = HistoryPanelController()
    private let settingsWindowController = SettingsWindowController()
    private var lastFrontmostApplication: NSRunningApplication?

    private var cancellables: Set<AnyCancellable> = []
    private var started = false

    init(
        settings: SettingsStore = SettingsStore(),
        historyStore: ClipboardHistoryStore = ClipboardHistoryStore()
    ) {
        self.settings = settings
        self.historyStore = historyStore
        self.items = historyStore.items

        self.monitor = ClipboardMonitor(
            isPaused: { settings.isCapturePaused },
            onTextCaptured: { [weak historyStore, weak settings] text in
                guard let historyStore, let settings else { return }
                Task { @MainActor in
                    historyStore.capture(text: text, maxItems: settings.maxItems)
                }
            },
            onImageCaptured: { [weak historyStore, weak settings] pngData in
                guard let historyStore, let settings else { return }
                Task { @MainActor in
                    historyStore.capture(imagePNGData: pngData, sourceLabel: "클립보드", maxItems: settings.maxItems)
                }
            }
        )

        self.screenshotMonitor = ScreenshotMonitor(
            isEnabled: { settings.autoCaptureScreenshotToClipboard },
            onScreenshotDetected: { [weak historyStore, weak settings] pngData in
                guard let historyStore, let settings else { return }
                Task { @MainActor in
                    historyStore.capture(imagePNGData: pngData, sourceLabel: "스크린샷", maxItems: settings.maxItems)
                    _ = PasteService.copyImageToPasteboard(pngData: pngData)
                }
            }
        )

        bindStores()
        configureHotKeyCallback()
        panelController.onDidClose = { [weak self] in
            Task { @MainActor in
                self?.isPanelVisible = false
            }
        }

        startIfNeeded()
    }

    func startIfNeeded() {
        guard started == false else { return }
        started = true

        monitor.start()
        screenshotMonitor.start()
        historyStore.enforceLimit(settings.maxItems)
        applyHotKeyPreset(settings.hotKeyPreset, persist: false)
    }

    func togglePanel() {
        isPanelVisible ? closePanel() : openPanel()
    }

    func openPanel() {
        let frontmost = NSWorkspace.shared.frontmostApplication
        if frontmost?.processIdentifier != ProcessInfo.processInfo.processIdentifier {
            lastFrontmostApplication = frontmost
        }

        panelSessionID = UUID()
        panelController.show(controller: self)
        isPanelVisible = true
    }

    func closePanel() {
        panelController.close()
        isPanelVisible = false
    }

    func filteredItems(for query: String) -> [ClipboardItem] {
        historyStore.filtered(by: query)
    }

    func paste(item: ClipboardItem) {
        closePanel()

        switch PasteService.paste(item: item, targetApplication: lastFrontmostApplication) {
        case .success:
            infoMessage = "\"\(item.preview)\" 붙여넣기 완료"
            errorMessage = nil
        case .clipboardWriteFailed:
            errorMessage = "클립보드 기록을 시스템 클립보드로 복사하지 못했습니다."
        case .accessibilityDenied:
            infoMessage = "접근성 권한이 없어 자동 붙여넣기에 실패했습니다. 클립보드는 복사되었으니 ⌘V로 수동 붙여넣기 해주세요."
            errorMessage = nil
        case .eventCreationFailed:
            errorMessage = "붙여넣기 이벤트를 생성하지 못했습니다. 접근성 권한 및 포커스 앱 상태를 확인해주세요."
        }
    }

    func delete(itemID: UUID) {
        historyStore.delete(id: itemID)
    }

    func clearAll() {
        historyStore.clear()
    }

    func setCapturePaused(_ paused: Bool) {
        settings.isCapturePaused = paused
        infoMessage = paused ? "클립 기록이 일시 중지되었습니다." : "클립 기록이 다시 시작되었습니다."
        errorMessage = nil
    }

    func setMaxItems(_ count: Int) {
        guard SettingsStore.allowedMaxItems.contains(count) else { return }
        settings.maxItems = count
        historyStore.enforceLimit(count)
        infoMessage = "최대 저장 개수를 \(count)개로 변경했습니다."
        errorMessage = nil
    }

    func setHotKeyPreset(id: String) {
        let preset = HotKeyPreset.from(id: id)
        applyHotKeyPreset(preset, persist: true)
    }

    func setLaunchAtLogin(_ enabled: Bool) {
        let previous = settings.launchAtLogin

        switch LaunchAtLoginService.apply(enabled: enabled) {
        case .success:
            settings.launchAtLogin = enabled
            infoMessage = enabled ? "시작 시 자동 실행을 활성화했습니다." : "시작 시 자동 실행을 비활성화했습니다."
            errorMessage = nil
        case let .failure(error):
            settings.launchAtLogin = previous
            errorMessage = "자동 실행 설정에 실패했습니다: \(error.localizedDescription)"
        }
    }

    func setAutoCaptureScreenshotToClipboard(_ enabled: Bool) {
        settings.autoCaptureScreenshotToClipboard = enabled
        infoMessage = enabled ? "스크린샷 자동 클립보드 저장을 활성화했습니다." : "스크린샷 자동 클립보드 저장을 비활성화했습니다."
        errorMessage = nil
    }

    func requestAccessibilityPermissionFromSettings() {
        if PasteService.requestAccessibilityPermission() {
            infoMessage = "접근성 권한이 이미 활성화되어 있습니다."
            errorMessage = nil
            return
        }

        PasteService.openAccessibilitySettings()
        infoMessage = "접근성 권한 팝업이 보이지 않으면 시스템 설정 > 개인정보 보호 및 보안 > 손쉬운 사용에서 직접 허용해주세요."
        errorMessage = nil
    }

    func clearNotices() {
        infoMessage = nil
        errorMessage = nil
    }

    func openSettingsWindow() {
        settingsWindowController.show(controller: self)
    }

    private func bindStores() {
        historyStore.$items
            .receive(on: RunLoop.main)
            .sink { [weak self] newItems in
                self?.items = newItems
            }
            .store(in: &cancellables)

        settings.$maxItems
            .receive(on: RunLoop.main)
            .sink { [weak self] newLimit in
                self?.historyStore.enforceLimit(newLimit)
            }
            .store(in: &cancellables)
    }

    private func configureHotKeyCallback() {
        hotKeyManager.onKeyPressed = { [weak self] in
            Task { @MainActor in
                self?.togglePanel()
            }
        }
    }

    private func applyHotKeyPreset(_ preset: HotKeyPreset, persist: Bool) {
        let status = hotKeyManager.register(preset: preset)

        guard status == noErr else {
            errorMessage = "전역 단축키 등록에 실패했습니다(코드: \(status)). 다른 조합을 선택해주세요."
            return
        }

        if persist {
            settings.hotKeyPresetID = preset.id
        }

        infoMessage = "전역 단축키를 \(preset.title)로 적용했습니다."
        errorMessage = nil
    }
}
