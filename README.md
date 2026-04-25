# Vercel CLI - 원클릭 키트 (Windows)

> Windows에서 더블클릭 한 번으로 Vercel CLI를 설치하고, 31가지 기능을 메뉴로 쉽게 사용할 수 있는 배치 파일 모음입니다.

[English README](./README.en.md)

---

## 개요

Vercel CLI는 터미널(명령줄) 도구입니다. 개발 경험이 없으면 사용하기 어렵습니다.  
이 키트는 **더블클릭만으로** 설치·실행·삭제까지 모두 할 수 있도록 만든 Windows 전용 원클릭 패키지입니다.

---

## 필요 사항

| 항목 | 버전 | 설명 |
|------|------|------|
| Windows | 10 / 11 | 다른 OS 미지원 |
| Node.js | 18 이상 | [nodejs.org](https://nodejs.org) 에서 무료 설치 |
| 인터넷 연결 | — | 설치 시 필요 |

> Node.js가 없으면 INSTALL.bat 실행 시 안내 메시지가 표시됩니다.

---

## 폴더 구조

```
Vercel-CLI/
├── INSTALL.bat                  ← Vercel CLI 설치
├── RUN.bat                      ← Vercel CLI 실행 (전체 메뉴)
├── UNINSTALL.bat                ← Vercel CLI 삭제
├── Vercel-CLI_One-Click_Kit.7z  ← 위 파일 압축본 (배포용)
├── .gitignore
├── LICENSE
├── README.md                    ← 이 파일 (한국어)
└── README.en.md                 ← 영어 문서
```

---

## 사용 방법

### 1단계 — 설치

`INSTALL.bat` 파일을 **더블클릭**합니다.

- Node.js 버전 자동 확인
- npm 경로 자동 설정
- `npm install -g vercel` 자동 실행
- 이미 설치된 경우 업데이트 여부 선택 가능

### 2단계 — 실행

`RUN.bat` 파일을 **더블클릭**합니다.

아래와 같은 메뉴가 열립니다. 숫자를 입력하고 Enter를 누르면 해당 기능이 실행됩니다.

```
============================================================
  Vercel CLI - Easy Menu
============================================================

  --- Deploy and Run ---
   1. Deploy (Preview)
   2. Deploy (Production)
   3. Dev Server (run locally)
   4. Redeploy last build

  --- Account ---
   5. Login
   6. Logout
   7. Who Am I
   8. Teams
   9. Switch Team

  --- Project Info ---
  10. Link Project
  11. List Deployments
  12. Inspect a Deploy
  13. View Logs
  14. Open in Browser

  --- Environment Variables ---
  15. List Env Variables
  16. Add Env Variable
  17. Remove Env Variable
  18. Pull Env to .env file

  --- Domains ---
  19. List Domains
  20. Add Domain
  21. Remove Domain

  --- Advanced ---
  22. Promote Deploy
  23. Rollback Deploy
  24. Remove Deploy
  25. Pull Project Settings
  26. Init New Project
  27. Alias (custom URL)
  28. DNS Records

  --- Tools ---
  29. Version Check
  30. Update Vercel CLI
  31. Help

   0. Exit
============================================================
```

### 3단계 — 삭제 (필요 시)

`UNINSTALL.bat` 파일을 **더블클릭**합니다.

- Vercel CLI npm 패키지 제거
- `~/.vercel` 전역 설정 폴더 삭제 여부 선택
- 로컬 `.vercel` 폴더 삭제 여부 선택

---

## 처음 사용하는 분을 위한 가이드

코딩을 한 번도 해보지 않으셨어도 괜찮습니다. 아래 순서대로 따라오세요.

**Vercel이란?**  
웹사이트나 앱을 인터넷에 올려서 누구나 볼 수 있게 해주는 무료 서비스입니다.

**처음 사용 순서:**

1. [Node.js 다운로드](https://nodejs.org) → **LTS** 버튼 클릭 → 설치
2. `INSTALL.bat` 더블클릭 → 화면의 안내를 따라 완료될 때까지 기다리기
3. `RUN.bat` 더블클릭 → 메뉴에서 `5` 입력 → Enter → Vercel 계정 로그인
4. 배포하고 싶은 폴더에서 `RUN.bat` 실행 → `2` 입력 → 프로덕션 배포

**자주 묻는 질문:**

- **"관리자 권한이 필요합니다" 오류가 뜨면?**  
  → bat 파일을 마우스 오른쪽 클릭 → "관리자 권한으로 실행"

- **설치 후 `vercel`을 인식 못하면?**  
  → 터미널을 완전히 닫고 새로 열기. 그래도 안 되면 컴퓨터 재시작

- **어느 폴더에서 실행해야 하나요?**  
  → 배포하려는 프로젝트 폴더에 이 bat 파일들을 복사해서 사용하거나,  
  → RUN.bat를 실행한 뒤 프로젝트 폴더를 드래그해서 터미널에 끌어다 놓기

---

## 운영 시 주의사항

- `vercel env pull`로 받은 `.env` 파일에는 API 키 등 민감정보가 포함될 수 있습니다. **절대 GitHub에 올리지 마세요.** (`.gitignore`에 이미 제외 처리됨)
- `.vercel/` 폴더에는 프로젝트 연결 정보가 있습니다. **공유하지 마세요.** (`.gitignore`에 이미 제외 처리됨)
- Vercel 무료 플랜 기준: 배포 횟수 제한 있음. [가격 정책 확인](https://vercel.com/pricing)

---

## 라이선스

[MIT License](./LICENSE) — Copyright (c) 2026 SoDam AI Studio
