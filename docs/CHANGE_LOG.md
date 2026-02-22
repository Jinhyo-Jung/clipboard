# 변경 로그

이 문서는 최신 변경 내역이 상단에 오도록 유지한다.

## 2026-02-22 19:30 KST
- 일시: 2026-02-22 19:30 KST
- 유형: docs
- 요약: README(영/한)에 자동 붙여넣기 권한 캐시 초기화 트러블슈팅 섹션을 추가하고, 릴리스 브랜치명을 `release/mac-clipboard-v1.0.0`에서 `release/mac-clipboard-v1.1.0`으로 정리
- 변경 파일: `README.md`, `README.ko.md`, `docs/CHANGE_LOG.md`
- 검증 결과: README 양쪽에 동일 트러블슈팅 절차 반영 확인, `Add Images to README` 섹션 미존재 확인
- 리스크/후속 작업: 원격에 기존 `release/mac-clipboard-v1.0.0` 브랜치가 남아 있다면 푸시 시 신규 브랜치 업로드 및 기존 브랜치 정리 여부 결정 필요

## 2026-02-22 18:43 KST
- 일시: 2026-02-22 18:43 KST
- 유형: fix
- 요약: 접근성 권한을 방금 허용했는데도 자동 붙여넣기에서 즉시 반영되지 않던 문제를 보완하기 위해 붙여넣기 직전 `권한 요청 + 짧은 재확인 대기` 로직을 추가하고, 설정/초기 부트스트랩 경로를 동일 로직으로 통일
- 변경 파일: `Sources/ClipboardApp/Services/PasteService.swift`, `Sources/ClipboardApp/App/ClipboardAppController.swift`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공
- 리스크/후속 작업: macOS TCC 캐시가 손상된 환경에서는 최초 1회 `tccutil reset`이 여전히 필요할 수 있음

## 2026-02-22 18:34 KST
- 일시: 2026-02-22 18:34 KST
- 유형: fix
- 요약: 설치/첫 실행 후 권한 누락으로 자동 붙여넣기가 차단되는 문제를 완화하기 위해 앱 시작 시 접근성/자동화 권한 부트스트랩을 추가하고, 설정의 접근성 버튼을 `권한 요청 -> 설정 열기` 순서로 변경해 손쉬운 사용 목록 미노출 이슈를 보완
- 변경 파일: `Sources/ClipboardApp/App/ClipboardAppController.swift`, `Sources/ClipboardApp/Services/PasteService.swift`, `SPEC.md`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공
- 리스크/후속 작업: macOS TCC 정책상 설치 단계에서 권한을 강제 승인할 수는 없고 사용자 승인 동작은 필수

## 2026-02-22 18:17 KST
- 일시: 2026-02-22 18:17 KST
- 유형: feat
- 요약: 자동 붙여넣기 실패 시 원인 파악을 위해 접근성/전면앱/PID/AppleScript 오류코드/CGEvent fallback 결과를 포함한 진단 리포트를 앱 메시지에 직접 표시하도록 추가
- 변경 파일: `Sources/ClipboardApp/Services/PasteService.swift`, `Sources/ClipboardApp/App/ClipboardAppController.swift`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공
- 리스크/후속 작업: 자동화 권한 팝업 허용 전에는 AppleScript 경로 실패가 지속될 수 있으며 진단 메시지 기반으로 권한 상태 확인 필요

## 2026-02-22 18:10 KST
- 일시: 2026-02-22 18:10 KST
- 유형: fix
- 요약: 자동 붙여넣기 실패 대응을 위해 `System Events` AppleScript 기반 `⌘V` 경로를 우선 적용하고, 실패 시 기존 CGEvent PID 전송 경로로 fallback 하도록 변경
- 변경 파일: `Sources/ClipboardApp/Services/PasteService.swift`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공
- 리스크/후속 작업: 최초 1회 macOS 자동화 권한(System Events 제어) 허용이 필요할 수 있음

## 2026-02-22 18:00 KST
- 일시: 2026-02-22 18:00 KST
- 유형: fix
- 요약: 자동 붙여넣기 무반응 문제를 줄이기 위해 `Command+V` 이벤트 주입을 이벤트 탭 브로드캐스트 우선 방식에서 현재 전면 앱 PID 직접 전송(`postToPid`) 우선 방식으로 변경
- 변경 파일: `Sources/ClipboardApp/Services/PasteService.swift`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공
- 리스크/후속 작업: 일부 앱에서 PID 직접 전송이 제한되면 AppleScript(`System Events`) fallback 경로 추가 필요

## 2026-02-22 17:53 KST
- 일시: 2026-02-22 17:53 KST
- 유형: fix
- 요약: 자동 붙여넣기 실패를 줄이기 위해 현재 전면 포커스 앱 우선 정책으로 붙여넣기 경로를 단순화하고, 히스토리 목록을 `ScrollViewReader` 기반으로 변경해 키보드 선택 이동 시 자동 스크롤 동기화 복구
- 변경 파일: `Sources/ClipboardApp/Services/PasteService.swift`, `Sources/ClipboardApp/UI/HistoryPanelView.swift`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공
- 리스크/후속 작업: 일부 앱에서 CGEvent 붙여넣기가 차단되면 AppleScript/입력소스별 대체 경로를 추가 검토

## 2026-02-22 17:45 KST
- 일시: 2026-02-22 17:45 KST
- 유형: feat
- 요약: 패널 포커스 비활성 상태에서도 단축키를 글로벌로 수신하도록 전역 키 모니터를 추가하고, Enter 지연 붙여넣기 경로를 유지한 채 더블클릭 붙여넣기를 동일 경로로 복원
- 변경 파일: `Sources/ClipboardApp/App/ClipboardAppController.swift`, `Sources/ClipboardApp/UI/HistoryPanelView.swift`, `SPEC.md`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공
- 리스크/후속 작업: 글로벌 키 모니터는 이벤트를 차단하지 않으므로 일부 앱에서 Enter 입력이 원본 앱에도 전달될 수 있음

## 2026-02-22 17:40 KST
- 일시: 2026-02-22 17:40 KST
- 유형: fix
- 요약: non-activating 패널 정책을 유지하면서 패널이 키 이벤트(↑/↓/Enter)를 받을 수 있도록 `makeKeyAndOrderFront` 및 `becomesKeyOnlyIfNeeded` 설정을 보강
- 변경 파일: `Sources/ClipboardApp/UI/HistoryPanelController.swift`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공
- 리스크/후속 작업: macOS 버전/입력기 조합에 따라 non-activating 키 윈도우 동작 차이가 있을 수 있어 필요 시 이벤트 탭 기반 보조 입력 경로 검토

## 2026-02-22 17:26 KST
- 일시: 2026-02-22 17:26 KST
- 유형: fix
- 요약: 히스토리 패널의 검색 UI/포커스 강제 동작을 제거하고, 패널 표시 시 앱 활성화 호출을 중단해 원래 작업 앱 포커스를 유지하도록 변경
- 변경 파일: `Sources/ClipboardApp/UI/HistoryPanelController.swift`, `Sources/ClipboardApp/UI/HistoryPanelView.swift`, `SPEC.md`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공
- 리스크/후속 작업: 패널을 비활성(non-activating)으로 표시하므로 환경에 따라 패널 키보드 탐색 반응성이 달라질 수 있음

## 2026-02-22 17:18 KST
- 일시: 2026-02-22 17:18 KST
- 유형: fix
- 요약: 패널 항목 선택 직후 붙여넣기 무반응 문제를 줄이기 위해 패널 닫힘 후 짧은 지연을 두고 붙여넣기를 실행하도록 조정했으며, 대상 앱 활성화 후 전면 전환 완료를 확인하는 대기 로직 추가
- 변경 파일: `Sources/ClipboardApp/App/ClipboardAppController.swift`, `Sources/ClipboardApp/Services/PasteService.swift`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공
- 리스크/후속 작업: 앱/입력필드별 시스템 이벤트 제한으로 자동 붙여넣기 실패 가능성은 일부 남아 있음

## 2026-02-22 16:58 KST
- 일시: 2026-02-22 16:58 KST
- 유형: fix
- 요약: `ddbb922`의 안정 동작 경로를 기준으로 히스토리 패널 입력 처리를 단순화(List 기반)하고 Enter 붙여넣기 경로를 복원했으며, 더블클릭 붙여넣기 기능은 제거
- 변경 파일: `Sources/ClipboardApp/UI/HistoryPanelView.swift`, `dist/ClipboardApp-v1.1.0.pkg`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공
- 리스크/후속 작업: 이미지 클립 항목의 썸네일 미리보기는 단순 목록 레이아웃으로 변경되어 기존 대비 표시 정보가 축소됨

## 2026-02-22 16:50 KST
- 일시: 2026-02-22 16:50 KST
- 유형: fix
- 요약: 정상 동작 기준(`ddbb922`)을 토대로 붙여넣기 경로를 복원/정리하고, 대상 앱 포커스 추적 보강 + `Command+V` 다중 이벤트 소스 재시도로 Enter/더블클릭 붙여넣기 무반응 회귀를 완화
- 변경 파일: `Sources/ClipboardApp/Services/PasteService.swift`, `Sources/ClipboardApp/App/ClipboardAppController.swift`, `SPEC.md`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공, `dist/ClipboardApp-v1.1.0.pkg` 재생성
- 리스크/후속 작업: 보안 입력 필드/일부 샌드박스 앱에서는 macOS 정책상 자동 붙여넣기 제한이 지속될 수 있음

## 2026-02-22 16:43 KST
- 일시: 2026-02-22 16:43 KST
- 유형: fix
- 요약: 붙여넣기 무반응 회귀를 줄이기 위해 과거 정상 동작 패턴에 맞춰 붙여넣기 경로를 단순화(비동기 지연/타깃 재해석/재시도 게이트 제거)하고 자동 접근성 프롬프트는 비활성 상태로 유지
- 변경 파일: `Sources/ClipboardApp/Services/PasteService.swift`, `Sources/ClipboardApp/App/ClipboardAppController.swift`, `dist/ClipboardApp-v1.1.0.pkg`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공, `dist/ClipboardApp-v1.1.0.pkg` 16:43 KST 재생성 확인
- 리스크/후속 작업: 앱/입력 필드 종류에 따른 CGEvent 제한은 여전히 존재할 수 있어 필요 시 붙여넣기 방식(NSEvent/AppleScript) fallback 추가 검토 필요

## 2026-02-22 16:30 KST
- 일시: 2026-02-22 16:30 KST
- 유형: fix
- 요약: 접근성 권한 자동 프롬프트 호출 경로를 제거하고 권한 미허용 시 안내 메시지 + 사용자의 수동 설정 열기 흐름으로 단순화
- 변경 파일: `Sources/ClipboardApp/App/ClipboardAppController.swift`, `dist/ClipboardApp-v1.1.0.pkg`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공
- 리스크/후속 작업: 접근성 권한이 없는 상태에서는 자동 붙여넣기 대신 수동 설정 유도만 수행

## 2026-02-22 16:23 KST
- 일시: 2026-02-22 16:23 KST
- 유형: fix
- 요약: 접근성 1회 자동 프롬프트 세션 플래그를 제거해 권한 미허용 시 매번 동일 경로로 프롬프트를 호출하도록 단순화
- 변경 파일: `Sources/ClipboardApp/App/ClipboardAppController.swift`, `dist/ClipboardApp-v1.1.0.pkg`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공
- 리스크/후속 작업: 권한 미허용 상태에서 붙여넣기를 반복 시 접근성 프롬프트 요청이 매번 발생할 수 있음

## 2026-02-22 16:10 KST
- 일시: 2026-02-22 16:10 KST
- 유형: refactor
- 요약: 붙여넣기 파이프라인을 재시도 중심으로 리팩토링해 포커스 전환 실패를 즉시 실패로 처리하지 않도록 개선하고, 패널 닫힘-붙여넣기 실행 사이에 지연을 두어 무반응 회귀를 완화했으며 더블클릭 붙여넣기 입력 처리를 제스처 기반으로 안정화
- 변경 파일: `Sources/ClipboardApp/Services/PasteService.swift`, `Sources/ClipboardApp/App/ClipboardAppController.swift`, `Sources/ClipboardApp/UI/HistoryPanelView.swift`, `dist/ClipboardApp-v1.1.0.pkg`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공
- 리스크/후속 작업: 자동 붙여넣기 성공 여부를 OS 레벨에서 100% 판별하기 어려워 일부 앱에서 실패 감지가 제한될 수 있으며 필요 시 대상 앱별 예외 정책 추가 검토 필요

## 2026-02-22 15:53 KST
- 일시: 2026-02-22 15:53 KST
- 유형: fix
- 요약: Enter/더블클릭 붙여넣기 무반응 회귀를 줄이기 위해 자동 붙여넣기 이벤트를 3회(소스/탭 조합 변경) 재시도하도록 보강하고, 히스토리 행의 더블클릭 처리 구조를 Button 기반에서 탭 제스처 기반으로 전환
- 변경 파일: `Sources/ClipboardApp/Services/PasteService.swift`, `Sources/ClipboardApp/UI/HistoryPanelView.swift`, `dist/ClipboardApp-v1.1.0.pkg`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공
- 리스크/후속 작업: 보안 입력 필드 등 일부 앱에서는 시스템 제한으로 자동 붙여넣기 실패 가능성이 남아 있어 대상 앱별 예외 안내 필요

## 2026-02-22 15:36 KST
- 일시: 2026-02-22 15:36 KST
- 유형: fix
- 요약: 권한 허용 후 Enter 붙여넣기 무반응 문제를 줄이기 위해 대상 앱 활성화 확인 로직을 보강하고 붙여넣기 타깃 결정을 안정화했으며, 히스토리 항목 더블클릭 시 즉시 붙여넣기 동작 추가
- 변경 파일: `Sources/ClipboardApp/Services/PasteService.swift`, `Sources/ClipboardApp/App/ClipboardAppController.swift`, `Sources/ClipboardApp/UI/HistoryPanelView.swift`, `dist/ClipboardApp-v1.1.0.pkg`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공
- 리스크/후속 작업: 특정 앱(보안 입력 필드/샌드박스 제한 앱)에서는 CGEvent 기반 자동 붙여넣기가 제한될 수 있어 대상 앱별 예외 안내 필요

## 2026-02-22 15:29 KST
- 일시: 2026-02-22 15:29 KST
- 유형: fix
- 요약: 설치 로그 분석으로 pkg가 기존 위치(`dist/ClipboardApp-v1.1.0.app`)로 재배치(relocate)되는 원인을 확인하고, `pkgbuild --root + component.plist(RootRelativeBundlePath/BundleIsRelocatable=false)` 기반으로 패키징 정책을 강화
- 변경 파일: `scripts/package_installer_pkg.sh`, `dist/ClipboardApp-v1.1.0.pkg`, `docs/CHANGE_LOG.md`
- 검증 결과: `scripts/package_installer_pkg.sh` 성공, pkg 내부 `install-location=/`, `Applications/ClipboardApp.app` payload 및 `postinstall` 포함 확인
- 리스크/후속 작업: 기존 receipt/재배치 메타데이터가 남아 있으면 이전 경로 우선 정책이 유지될 수 있어 receipt 정리 후 재설치 필요

## 2026-02-22 15:20 KST
- 일시: 2026-02-22 15:20 KST
- 유형: fix
- 요약: pkg 설치 후 앱 미노출 이슈를 추가 보강하기 위해 postinstall에서 시스템(`/Applications`) 및 타깃 경로를 모두 보정하도록 개선하고, 붙여넣기 이벤트 전송을 기존 동작으로 회귀해 권한 허용 후 Enter 붙여넣기 안정성을 복구
- 변경 파일: `scripts/package_installer_pkg.sh`, `Sources/ClipboardApp/Services/PasteService.swift`, `dist/ClipboardApp-v1.1.0.pkg`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공, pkg 내부 `postinstall` 스크립트 최신 내용 반영 확인
- 리스크/후속 작업: 기존 중복 설치본/Spotlight 캐시가 남아 있으면 실행 경로 혼선이 있을 수 있어 `/Applications/ClipboardApp.app` 기준으로만 실행 확인 권장

## 2026-02-22 15:19 KST
- 일시: 2026-02-22 15:19 KST
- 유형: fix
- 요약: 패키지 설치 누락 이슈를 완화하기 위해 pkg 생성 시 최신 release 바이너리로 앱 번들을 항상 재구성하고 `/Applications` 대상 postinstall 보정 스크립트를 안정화했으며, 붙여넣기 이벤트 전송을 기존 검증 방식으로 회귀
- 변경 파일: `scripts/package_installer_pkg.sh`, `Sources/ClipboardApp/Services/PasteService.swift`, `dist/ClipboardApp-v1.1.0.pkg`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/package_installer_pkg.sh` 성공, pkg 내부 `install-location=/Applications`/`postinstall` 확인
- 리스크/후속 작업: 로컬 환경의 기존 설치/권한 캐시 상태에 따라 첫 설치 동작이 달라질 수 있어 기존 항목 정리 후 재설치 필요

## 2026-02-22 15:04 KST
- 일시: 2026-02-22 15:04 KST
- 유형: fix
- 요약: pkg 설치 후 `/Applications/ClipboardApp.app`이 누락되는 문제를 완화하기 위해 패키징을 최신 release 바이너리 기반으로 재구성하고 postinstall 보정 스크립트를 추가했으며, 접근성 권한 최초 안내를 Enter 붙여넣기 시 1회 자동 호출하도록 조정
- 변경 파일: `scripts/package_installer_pkg.sh`, `Sources/ClipboardApp/App/ClipboardAppController.swift`, `dist/ClipboardApp-v1.1.0.pkg`, `docs/CHANGE_LOG.md`
- 검증 결과: `scripts/package_installer_pkg.sh` 성공, 패키지 내부 `install-location=/Applications` 및 `postinstall` 포함 확인, `swift build` 성공
- 리스크/후속 작업: 기존 설치본/권한 캐시가 남아 있으면 첫 실행 동작이 다를 수 있어 기존 앱 삭제 후 재설치 권장

## 2026-02-22 14:53 KST
- 일시: 2026-02-22 14:53 KST
- 유형: fix
- 요약: 패키지 설치 시 앱이 `/Applications`에 확실히 배치되도록 패키징 방식을 `productbuild --component`에서 `pkgbuild --root` 기반으로 변경하고 설치 대상 앱 이름을 `ClipboardApp.app`으로 고정
- 변경 파일: `scripts/package_installer_pkg.sh`, `README.md`, `README.ko.md`, `dist/ClipboardApp-v1.1.0.pkg`, `docs/CHANGE_LOG.md`
- 검증 결과: `pkgutil --expand-full` + `lsbom` 검증에서 `./Applications/ClipboardApp.app` 페이로드 확인, `swift build` 성공
- 리스크/후속 작업: 기존 중복 설치 흔적이 남아 있으면 Spotlight 결과와 손쉬운 사용 권한 목록이 즉시 정리되지 않을 수 있어 기존 앱/권한 항목 제거 후 재설치 권장

## 2026-02-22 14:39 KST
- 일시: 2026-02-22 14:39 KST
- 유형: fix
- 요약: 접근성 권한이 켜져 있어도 붙여넣기가 동작하지 않던 문제를 완화하기 위해 대상 앱 활성화 안정성과 키 이벤트 전송 경로를 보강하고, 권한 안내 메시지를 매 시도 시점에 확인 가능하도록 조정
- 변경 파일: `Sources/ClipboardApp/Services/PasteService.swift`, `Sources/ClipboardApp/App/ClipboardAppController.swift`, `dist/ClipboardApp-v1.1.0.pkg`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `dist/ClipboardApp-v1.1.0.pkg` 재생성 성공
- 리스크/후속 작업: 로컬에 남아 있는 중복/구버전 앱 엔트리로 인해 손쉬운 사용(TCC) 권한이 다른 앱 번들에 연결될 수 있어, 완전 삭제 후 재설치 및 권한 재등록 권장

## 2026-02-22 14:30 KST
- 일시: 2026-02-22 14:30 KST
- 유형: fix
- 요약: 클립보드 항목 붙여넣기 시 접근성 권한 안내가 반복되던 문제를 수정해 붙여넣기 경로에서는 권한 프롬프트를 호출하지 않고, 안내 메시지를 1회만 노출하도록 개선
- 변경 파일: `Sources/ClipboardApp/Services/PasteService.swift`, `Sources/ClipboardApp/App/ClipboardAppController.swift`, `dist/ClipboardApp-v1.1.0.pkg`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `dist/ClipboardApp-v1.1.0.pkg` 재생성 성공
- 리스크/후속 작업: `dist/ClipboardApp-v1.1.0.app`은 root 소유 상태로 직접 덮어쓰기 불가하여, 앱 번들 단일 정리는 sudo 권한으로 삭제 후 재생성 필요

## 2026-02-22 14:22 KST
- 일시: 2026-02-22 14:22 KST
- 유형: fix
- 요약: 설정의 언어 변경 시 발생하던 앱 강제 종료(재귀 didSet) 버그를 수정하고, 배포 산출물을 `ClipboardApp-v1.1.0` 단일 규칙으로 정리했으며 첨부 아이콘을 앱 번들과 설치 패키지에 반영
- 변경 파일: `SPEC.md`, `README.md`, `README.ko.md`, `Sources/ClipboardApp/Services/SettingsStore.swift`, `scripts/build_app_bundle.sh`, `scripts/package_installer_pkg.sh`, `scripts/sign_and_notarize.sh`, `.github/workflows/release.yml`, `docs/images/icon.png`, `dist/ClipboardApp-v1.1.0.app`, `dist/ClipboardApp-v1.1.0.pkg`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `scripts/build_app_bundle.sh` 성공, `scripts/package_installer_pkg.sh` 성공, `Info.plist`의 `CFBundleIconFile=AppIcon` 및 `CFBundleDevelopmentRegion=en` 확인, 앱 리소스 `AppIcon.icns` 생성 확인
- 리스크/후속 작업: 기존 `dist/ClipboardApp.app`은 root 소유로 현재 세션에서 삭제 불가하여, 완전 정리를 위해 로컬 sudo 권한으로 제거 필요

## 2026-02-22 14:05 KST
- 일시: 2026-02-22 14:05 KST
- 유형: fix
- 요약: 영어 기본 언어 반영을 위해 앱 번들 개발 리전을 `en`으로 조정하고, README(영/한)에서 일반 사용자 비대상 이미지 추가 가이드를 제거했으며 최신 코드 기준 설치 패키지를 재생성
- 변경 파일: `README.md`, `README.ko.md`, `scripts/build_app_bundle.sh`, `dist/ClipboardApp-installer.pkg`, `dist/ClipboardApp-updated.app`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build -c release` 성공, `dist/ClipboardApp-updated.app/Contents/Info.plist`의 `CFBundleDevelopmentRegion=en` 확인, `productbuild`로 `dist/ClipboardApp-installer.pkg` 재생성 성공
- 리스크/후속 작업: 기존 `dist/ClipboardApp.app`이 root 소유라 현재 세션에서 덮어쓰기 불가하며, 해당 파일 교체는 로컬 sudo 권한으로 정리 필요

## 2026-02-22 13:58 KST
- 일시: 2026-02-22 13:58 KST
- 유형: feat
- 요약: 앱 기본 언어를 영어로 설정하고 설정 창에서 영어/한국어 전환 시 메뉴바/히스토리/알림 메시지를 즉시 다국어로 반영하도록 로컬라이제이션 계층 추가
- 변경 파일: `SPEC.md`, `Sources/ClipboardApp/App/ClipboardAppController.swift`, `Sources/ClipboardApp/Localization/AppLanguage.swift`, `Sources/ClipboardApp/Localization/AppStrings.swift`, `Sources/ClipboardApp/Models/ClipboardItem.swift`, `Sources/ClipboardApp/Models/HotKeyPreset.swift`, `Sources/ClipboardApp/Services/SettingsStore.swift`, `Sources/ClipboardApp/UI/HistoryPanelView.swift`, `Sources/ClipboardApp/UI/MenuBarMenuView.swift`, `Sources/ClipboardApp/UI/SettingsView.swift`, `Sources/ClipboardApp/UI/SettingsWindowController.swift`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공
- 리스크/후속 작업: 기존 히스토리에 저장된 이미지 source label은 저장 당시 언어 문자열을 유지하므로 필요 시 마이그레이션 정책 검토 필요

## 2026-02-22 13:49 KST
- 일시: 2026-02-22 13:49 KST
- 유형: docs
- 요약: README를 영어 기본 문서로 전환하고 한국어 문서를 `README.ko.md`로 분리하여 다국어 접근성을 개선
- 변경 파일: `README.md`, `README.ko.md`, `docs/CHANGE_LOG.md`
- 검증 결과: 문서 링크(`README.md` ↔ `README.ko.md`) 및 이미지 경로 확인 완료
- 리스크/후속 작업: 추후 기능 변경 시 두 문서 동시 업데이트 필요

## 2026-02-22 12:52 KST
- 일시: 2026-02-22 12:52 KST
- 유형: docs
- 요약: `dist/` 산출물을 Git 추적 대상으로 전환하고 README에 GitHub Releases/브랜치에서 배포파일 다운로드 절차를 추가
- 변경 파일: `.gitignore`, `README.md`, `docs/CHANGE_LOG.md`
- 검증 결과: 문서 경로 및 배포 안내 흐름 확인 완료
- 리스크/후속 작업: 대용량 바이너리 관리가 필요하면 추후 GitHub Release 자산 업로드 중심으로 전환 권장

## 2026-02-22 11:29 KST
- 일시: 2026-02-22 11:29 KST
- 유형: docs
- 요약: README를 비개발자 우선 구조로 재작성하고 `docs/images` 스크린샷 4종을 설치/사용 섹션에 배치
- 변경 파일: `README.md`, `docs/images/앱아이콘.png`, `docs/images/설치화면.png`, `docs/images/window.png`, `docs/images/clipboard_설정창.png`, `docs/CHANGE_LOG.md`
- 검증 결과: 문서 링크/이미지 경로 확인 완료
- 리스크/후속 작업: 이미지 파일명이 한글이므로 외부 자동화 연동 시 UTF-8 경로 처리 확인 필요

## 2026-02-22 11:21 KST
- 일시: 2026-02-22 11:21 KST
- 유형: docs
- 요약: README의 더블클릭 실행 안내에서 `.pkg`/`.app` 경로를 `dist/` 기준으로 명확화
- 변경 파일: `README.md`, `docs/CHANGE_LOG.md`
- 검증 결과: 문서 경로 표기 확인 완료
- 리스크/후속 작업: 배포 스크립트 산출물 경로가 바뀌면 README 경로도 함께 갱신 필요

## 2026-02-22 11:15 KST
- 일시: 2026-02-22 11:15 KST
- 유형: docs
- 요약: README를 무료 사용자 배포 모드 기준으로 정리하고 더블클릭 실행 대상 파일(`.pkg`/`.app`) 안내를 명확화
- 변경 파일: `README.md`, `docs/CHANGE_LOG.md`
- 검증 결과: 문서 교차 확인 완료
- 리스크/후속 작업: 향후 공식 서명/노터라이즈 배포 전환 시 README의 무료 배포 안내와 유료 배포 안내를 릴리스 태그별로 분리 권장

## 2026-02-22 10:36 KST
- 일시: 2026-02-22 10:36 KST
- 유형: fix
- 요약: 설정 창의 접근성 권한 요청 동작을 컨트롤러 기반으로 보강하고 시작 시 자동 실행 오류 메시지를 실행 컨텍스트별로 명확화
- 변경 파일: `Sources/ClipboardApp/App/ClipboardAppController.swift`, `Sources/ClipboardApp/Services/LaunchAtLoginService.swift`, `Sources/ClipboardApp/UI/SettingsView.swift`, `docs/CHANGE_LOG.md`
- 검증 결과: `swift build` 성공, `swift run ClipboardApp` 실행 스모크 테스트 성공
- 리스크/후속 작업: 자동 실행은 실제 서명된 `/Applications` 설치본에서 최종 확인 필요

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
