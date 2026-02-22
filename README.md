# ClipboardApp (macOS)

전역 단축키 기반 클립보드 히스토리 앱입니다.

- 히스토리 패널 열기: `⌃⌥V`
- 탐색: `↑/↓`, `⌘1..9`
- 붙여넣기: `Enter`
- 삭제: `⌘⌫` / 전체 삭제 `⇧⌘⌫`
- 스크린샷 자동 반영: `⌘⇧5` 캡처 결과를 Desktop에서 감지해 이미지 클립으로 저장

## 주요 기능
- 텍스트/이미지 클립 히스토리 저장
- 검색 필터
- 메뉴바 상주
- 설정 창(저장 개수, 단축키, 자동 실행, 스크린샷 자동 저장 토글)
- 접근성 권한 안내 및 수동 붙여넣기 대체 흐름

## 로컬 실행
```bash
cd /Users/kkongwang/Documents/clipboard
swift run ClipboardApp
```

## 더블클릭 설치용 `.app` / `.pkg` 생성

### 1) 앱 번들 생성
```bash
cd /Users/kkongwang/Documents/clipboard
./scripts/build_app_bundle.sh
```
생성 결과:
- `dist/ClipboardApp.app`

### 2) 설치 패키지 생성 (더블클릭 설치)
```bash
./scripts/package_installer_pkg.sh
```
생성 결과:
- `dist/ClipboardApp-installer.pkg`

`ClipboardApp-installer.pkg`를 더블클릭하면 `/Applications`에 설치됩니다.

## 서명 / 노터라이즈

### 사전 준비
- Apple Developer 계정
- Keychain에 Developer ID 인증서 설치
- (노터라이즈용) 앱 전용 비밀번호 생성

### 환경변수
```bash
export APP_SIGN_IDENTITY="Developer ID Application: <이름> (<TEAMID>)"
export INSTALLER_SIGN_IDENTITY="Developer ID Installer: <이름> (<TEAMID>)"

export APPLE_ID="you@example.com"
export APPLE_TEAM_ID="TEAMID1234"
export APPLE_APP_PASSWORD="xxxx-xxxx-xxxx-xxxx"
```

### 실행
```bash
./scripts/sign_and_notarize.sh
```

## CI 릴리스 템플릿
- `fastlane/Fastfile`
  - `fastlane mac build_release`
  - `fastlane mac notarize_release`
- `.github/workflows/release.yml`
  - 수동 실행(`workflow_dispatch`)으로 `.app`/`.pkg` 아티팩트 생성
  - 시크릿이 설정되어 있으면 서명/노터라이즈 단계 실행

## 서명 점검(스킬 기반)
```bash
/Users/kkongwang/.codex/skills/mac-signing-notarization-check/scripts/signing_check.sh dist/ClipboardApp.app
```

## GitHub README에 이미지 올리는 방법

### 방법 A (권장): 저장소에 이미지 파일 추가
1. 이미지 파일을 `docs/images/`에 넣습니다. 예: `docs/images/screenshot-main.png`
2. 커밋/푸시합니다.
3. README에서 아래처럼 참조합니다.

```md
![앱 실행 화면](docs/images/screenshot-main.png)
```

### 방법 B: GitHub 이슈/릴리즈 업로드 URL 사용
- 외부 URL은 링크 만료/접근권한 이슈가 생길 수 있어 방법 A를 권장합니다.

## README 이미지 예시

아래는 경로만 잡아둔 예시입니다. 파일 추가 후 정상 표시됩니다.

![히스토리 패널 예시](docs/images/screenshot-history-panel.png)

## 권한 관련 안내
- 자동 붙여넣기는 `손쉬운 사용(Accessibility)` 권한이 필요합니다.
- 권한이 없으면 클립보드 복사만 수행되며 사용자가 `⌘V`로 수동 붙여넣기 가능합니다.
