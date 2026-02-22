#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="ClipboardApp"
APP_PATH="${ROOT_DIR}/dist/${APP_NAME}.app"
PKG_PATH="${ROOT_DIR}/dist/${APP_NAME}-installer.pkg"

if [[ ! -d "$APP_PATH" ]]; then
  echo "오류: 앱 번들이 없습니다. scripts/build_app_bundle.sh 실행 후 다시 시도하세요." >&2
  exit 1
fi

if [[ -z "${APP_SIGN_IDENTITY:-}" ]]; then
  echo "오류: APP_SIGN_IDENTITY 환경변수가 필요합니다. 예: Developer ID Application: ..." >&2
  exit 1
fi

codesign --force --deep --options runtime --timestamp --sign "$APP_SIGN_IDENTITY" "$APP_PATH"
codesign --verify --deep --strict --verbose=2 "$APP_PATH"
spctl --assess --type execute --verbose "$APP_PATH" || true

if [[ -n "${INSTALLER_SIGN_IDENTITY:-}" ]]; then
  "${ROOT_DIR}/scripts/package_installer_pkg.sh"
else
  INSTALLER_SIGN_IDENTITY="$APP_SIGN_IDENTITY" "${ROOT_DIR}/scripts/package_installer_pkg.sh"
fi

if [[ -z "${APPLE_ID:-}" || -z "${APPLE_TEAM_ID:-}" || -z "${APPLE_APP_PASSWORD:-}" ]]; then
  echo "주의: APPLE_ID/APPLE_TEAM_ID/APPLE_APP_PASSWORD 가 없어 노터라이즈를 건너뜁니다." >&2
  exit 0
fi

xcrun notarytool submit "$PKG_PATH" \
  --apple-id "$APPLE_ID" \
  --team-id "$APPLE_TEAM_ID" \
  --password "$APPLE_APP_PASSWORD" \
  --wait

xcrun stapler staple "$APP_PATH" || true
xcrun stapler staple "$PKG_PATH" || true

echo "서명/노터라이즈 절차 완료"
