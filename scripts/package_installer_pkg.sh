#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_NAME="ClipboardApp"
APP_PATH="${ROOT_DIR}/dist/${APP_NAME}.app"
PKG_PATH="${ROOT_DIR}/dist/${APP_NAME}-installer.pkg"

if [[ ! -d "$APP_PATH" ]]; then
  echo "오류: 앱 번들이 없습니다. 먼저 scripts/build_app_bundle.sh 를 실행하세요." >&2
  exit 1
fi

rm -f "$PKG_PATH"

if [[ -n "${INSTALLER_SIGN_IDENTITY:-}" ]]; then
  productbuild \
    --component "$APP_PATH" /Applications \
    --sign "$INSTALLER_SIGN_IDENTITY" \
    "$PKG_PATH"
else
  productbuild \
    --component "$APP_PATH" /Applications \
    "$PKG_PATH"
fi

echo "설치 패키지 생성 완료: ${PKG_PATH}"
