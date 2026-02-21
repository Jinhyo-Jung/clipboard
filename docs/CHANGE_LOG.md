# 변경 로그

이 문서는 최신 변경 내역이 상단에 오도록 유지한다.

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
