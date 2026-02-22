# 변경 로그

이 문서는 최신 변경 내역이 상단에 오도록 유지한다.

## 2026-02-22 10:25 KST
- 일시: 2026-02-22 10:25 KST
- 유형: feat
- 요약: 더블클릭 설치용 `.app`/`.pkg` 배포 스크립트, 서명/노터라이즈 자동화 스크립트, README(설치/배포/이미지 업로드 가이드) 및 fastlane/GitHub Actions 릴리스 템플릿 추가
- 변경 파일: `.gitignore`, `README.md`, `SPEC.md`, `fastlane/Fastfile`, `.github/workflows/release.yml`, `scripts/build_app_bundle.sh`, `scripts/package_installer_pkg.sh`, `scripts/sign_and_notarize.sh`, `Sources/ClipboardApp/App/ClipboardAppController.swift`, `Sources/ClipboardApp/Models/ClipboardItem.swift`, `Sources/ClipboardApp/Services/ClipboardHistoryStore.swift`, `Sources/ClipboardApp/Services/ClipboardMonitor.swift`, `Sources/ClipboardApp/Services/ImageConversion.swift`, `Sources/ClipboardApp/Services/PasteService.swift`, `Sources/ClipboardApp/Services/ScreenshotMonitor.swift`, `Sources/ClipboardApp/Services/SettingsStore.swift`, `Sources/ClipboardApp/UI/HistoryPanelView.swift`, `Sources/ClipboardApp/UI/MenuBarMenuView.swift`, `Sources/ClipboardApp/UI/SettingsView.swift`, `Sources/ClipboardApp/UI/SettingsWindowController.swift`, `docs/CHANGE_LOG.md`, `docs/images/.gitkeep`
- 검증 결과: `swift build` 성공, `scripts/build_app_bundle.sh` 성공, `scripts/package_installer_pkg.sh` 성공, 서명 점검 스크립트 실행(`notarytool` 사용 가능 확인)
- 리스크/후속 작업: 현재 로컬 키체인에 Developer ID 인증서가 없어 공식 서명/노터라이즈는 미완료 상태이며 인증서/Apple 자격정보 주입 후 `scripts/sign_and_notarize.sh` 실행 필요

## 2026-02-22 10:07 KST
- 일시: 2026-02-22 10:07 KST
- 유형: feat
- 요약: `⌘⇧5` 스크린샷 결과를 자동으로 감지해 이미지 클립 히스토리 및 시스템 클립보드에 저장하는 기능 추가
- 변경 파일: `SPEC.md`, `Sources/ClipboardApp/App/ClipboardAppController.swift`, `Sources/ClipboardApp/Models/ClipboardItem.swift`, `Sources/ClipboardApp/Services/ClipboardHistoryStore.swift`, `Sources/ClipboardApp/Services/ClipboardMonitor.swift`, `Sources/ClipboardApp/Services/ImageConversion.swift`, `Sources/ClipboardApp/Services/PasteService.swift`, `Sources/ClipboardApp/Services/ScreenshotMonitor.swift`, `Sources/ClipboardApp/Services/SettingsStore.swift`, `Sources/ClipboardApp/UI/HistoryPanelView.swift`, `Sources/ClipboardApp/UI/MenuBarMenuView.swift`, `Sources/ClipboardApp/UI/SettingsView.swift`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `swift run ClipboardApp` 실행 스모크 테스트 성공
- 리스크/후속 작업: 스크린샷 저장 경로가 Desktop이 아닐 경우 자동 감지 범위를 사용자 지정 경로로 확장 필요

## 2026-02-22 09:57 KST
- 일시: 2026-02-22 09:57 KST
- 유형: fix
- 요약: 메뉴바의 설정 열기 동작을 전용 설정 윈도우로 교체하고 히스토리 패널의 기본 상단 노출/선택-스크롤 동기화를 개선
- 변경 파일: `Sources/ClipboardApp/App/ClipboardAppController.swift`, `Sources/ClipboardApp/UI/HistoryPanelView.swift`, `Sources/ClipboardApp/UI/MenuBarMenuView.swift`, `Sources/ClipboardApp/UI/SettingsWindowController.swift`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `swift run ClipboardApp` 실행 스모크 테스트 성공
- 리스크/후속 작업: 항목 수가 매우 많을 때 애니메이션 스크롤 빈도 최적화 검토 필요

## 2026-02-21 22:34 KST
- 일시: 2026-02-21 22:34 KST
- 유형: fix
- 요약: 히스토리 패널 키보드 이동(`↑/↓`) 비동작과 붙여넣기 타깃 앱 포커스 유지 문제를 수정
- 변경 파일: `Sources/ClipboardApp/App/ClipboardAppController.swift`, `Sources/ClipboardApp/Services/PasteService.swift`, `Sources/ClipboardApp/UI/HistoryPanelView.swift`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `swift run ClipboardApp` 프로세스 기동/종료 스모크 테스트 확인
- 리스크/후속 작업: 실제 GUI 상호작용(`↑/↓`, `Enter` 붙여넣기)은 사용자 환경에서 권한/포커스 상태에 따라 차이가 있을 수 있어 수동 확인 필요

## 2026-02-21 22:20 KST
- 일시: 2026-02-21 22:20 KST
- 유형: feat
- 요약: `SPEC.md` 기반으로 macOS 메뉴바 클립보드 앱 MVP(히스토리/검색/전역 단축키/붙여넣기/설정)를 SwiftUI + AppKit으로 구현
- 변경 파일: `.gitignore`, `Package.swift`, `Sources/ClipboardApp/ClipboardApp.swift`, `Sources/ClipboardApp/App/ClipboardAppController.swift`, `Sources/ClipboardApp/Models/ClipboardItem.swift`, `Sources/ClipboardApp/Models/HotKeyPreset.swift`, `Sources/ClipboardApp/Services/ClipboardHistoryStore.swift`, `Sources/ClipboardApp/Services/ClipboardMonitor.swift`, `Sources/ClipboardApp/Services/GlobalHotKeyManager.swift`, `Sources/ClipboardApp/Services/LaunchAtLoginService.swift`, `Sources/ClipboardApp/Services/PasteService.swift`, `Sources/ClipboardApp/Services/SettingsStore.swift`, `Sources/ClipboardApp/UI/HistoryPanelController.swift`, `Sources/ClipboardApp/UI/HistoryPanelView.swift`, `Sources/ClipboardApp/UI/KeyboardEventMonitorView.swift`, `Sources/ClipboardApp/UI/MenuBarMenuView.swift`, `Sources/ClipboardApp/UI/SettingsView.swift`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, 전역 `xcodebuild`는 Xcode 미설치(활성 경로: CommandLineTools)로 실행 불가 확인
- 리스크/후속 작업: 실제 배포용 서명/노터라이즈 및 `xcodebuild` 기반 CI 검증은 Xcode 설치 환경에서 추가 필요

## 2026-02-21 22:10 KST
- 일시: 2026-02-21 22:10 KST
- 유형: docs
- 요약: macOS 앱 개발용 Codex 스킬 8종을 `$CODEX_HOME/skills`에 생성하고 스크립트/참조문서/에이전트 메타데이터를 구성
- 변경 파일: `docs/CHANGE_LOG.md` (스킬 생성 경로: `/Users/kkongwang/.codex/skills/mac-*`)
- 검증 결과: `quick_validate.py` 8개 스킬 통과, 쉘 스크립트 문법 검사 통과
- 리스크/후속 작업: 실제 프로젝트 적용 시 각 스킬의 기본 명령 인자(스킴/워크스페이스/배포 lane)를 저장소별로 보정 필요

## 2026-02-21 21:59 KST
- 일시: 2026-02-21 21:59 KST
- 유형: docs
- 요약: 운영 규칙을 문서 역할별로 분리(`AGENTS.md`, `CONTRIBUTING.md`, `SECURITY.md`)하고 `SPEC.md`를 제품 스펙 중심으로 정리
- 변경 파일: `SPEC.md`, `AGENTS.md`, `CONTRIBUTING.md`, `SECURITY.md`, `docs/CHANGE_LOG.md`
- 검증 결과: 문서 생성/갱신 후 역할 분리 및 참조 경로 확인 완료
- 리스크/후속 작업: 추후 릴리스 체크리스트 문서가 필요하면 `docs/` 하위에 별도 추가

## 2026-02-21 21:56 KST
- 일시: 2026-02-21 21:56 KST
- 유형: docs
- 요약: 민감 정보(IP) 포함 문서 `docs/WOL_REMOTE_POWER_ON.md`를 Git 추적 제외로 설정
- 변경 파일: `.gitignore`, `docs/CHANGE_LOG.md`
- 검증 결과: `git status`에서 해당 파일이 추적 대상에서 제외됨을 확인
- 리스크/후속 작업: 민감정보 문서는 동일 방식으로 `.gitignore` 유지 관리 필요

## 2026-02-21 19:00 KST
- 일시: 2026-02-21 19:00 KST
- 유형: docs
- 요약: 프로젝트 운영 규칙 v2를 저장소 문서/설정에 반영
- 변경 파일: `.gitignore`, `SPEC.md`, `docs/CHANGE_LOG.md`
- 검증 결과: 파일 생성 및 규칙 반영 여부 확인 완료
- 리스크/후속 작업: `origin` 연결 완료, `git@github.com` SSH 공개키 권한 등록 후 푸시 필요

## 기록 템플릿
- 일시: YYYY-MM-DD HH:mm TZ
- 유형: feat | fix | docs | refactor | chore
- 요약: 변경 핵심 내용
- 변경 파일: 파일 경로 목록
- 검증 결과: 확인한 테스트/검증 내용
- 리스크/후속 작업: 남은 이슈 또는 다음 작업
