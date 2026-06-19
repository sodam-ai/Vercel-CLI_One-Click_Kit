@echo off
chcp 949 >nul
setlocal EnableDelayedExpansion
title Vercel CLI - 메뉴 (Menu)

REM ================================================================
REM   Vercel CLI - 쉬운 메뉴 / Easy Menu
REM   첫 화면은 심플하게, 기능은 분류별로 전부 / Simple front, full features by group
REM   인코딩: CP949 (한글) + CRLF, chcp 949
REM   ** 관리자 권한 필요 없음 / No admin needed **
REM ================================================================

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

REM === npm 전역 폴더를 PATH에 추가 / Add npm global bin to PATH ===
set "NPM_PREFIX="
for /f "tokens=*" %%p in ('npm config get prefix 2^>nul') do set "NPM_PREFIX=%%p"
if not "!NPM_PREFIX!"=="" set "PATH=!NPM_PREFIX!;!PATH!"

REM === vercel 설치 확인 / Check vercel exists ===
where vercel >nul 2>&1
if !ERRORLEVEL! NEQ 0 goto :ERR_NOT_INSTALLED

set "VERCEL_VER="
for /f "tokens=*" %%v in ('vercel --version 2^>nul') do set "VERCEL_VER=%%v"

REM ================================================================
REM   메인 메뉴 / MAIN MENU  (심플: 자주 쓰는 것 + 분류)
REM ================================================================
:MAIN_MENU
cls
echo.
echo ============================================================
echo   Vercel CLI - 쉬운 메뉴 (Easy Menu)
echo   버전(Version) : !VERCEL_VER!
echo   폴더(Folder)  : %SCRIPT_DIR%
echo ------------------------------------------------------------
echo   처음이면(First time):  3(로그인 Login)  -^>  1(미리보기 배포 Preview)
echo   관리자 권한 필요 없음 / No admin needed
echo ============================================================
echo.
echo   == 자주 쓰는 것 (Most used) ==
echo    1.  미리보기 배포    Deploy Preview     (임시 주소, 안전)
echo    2.  진짜 공개 배포   Deploy Production  (방문자가 바로 봄, 주의)
echo    3.  로그인           Login
echo    4.  내 계정 확인     Who Am I
echo.
echo   == 분류별 더보기 (More, by group) ==
echo    5.  계정 / 팀        Account / Team
echo    6.  프로젝트 / 배포  Project / Deploys
echo    7.  환경 변수        Environment Variables
echo    8.  도메인 / 주소    Domains / Address
echo    9.  고급 기능        Advanced
echo   10.  도구             Tools (버전/업데이트/도움말)
echo   11.  업데이트          Update      (Vercel을 최신 버전으로)
echo.
echo    0.  끝내기           Exit
echo.
echo ============================================================

set "MENU_CHOICE="
set /p "MENU_CHOICE=   번호 입력 / Pick a number [0-11]: "

if "!MENU_CHOICE!"=="0" goto :EXIT_APP
if "!MENU_CHOICE!"=="1" goto :F_DEPLOY_PREVIEW
if "!MENU_CHOICE!"=="2" goto :F_DEPLOY_PROD
if "!MENU_CHOICE!"=="3" goto :F_LOGIN
if "!MENU_CHOICE!"=="4" goto :F_WHOAMI
if "!MENU_CHOICE!"=="5" goto :CAT_ACCOUNT
if "!MENU_CHOICE!"=="6" goto :CAT_PROJECT
if "!MENU_CHOICE!"=="7" goto :CAT_ENV
if "!MENU_CHOICE!"=="8" goto :CAT_DOMAIN
if "!MENU_CHOICE!"=="9" goto :CAT_ADVANCED
if "!MENU_CHOICE!"=="10" goto :CAT_TOOLS
if "!MENU_CHOICE!"=="11" goto :F_UPDATE

echo.
echo   [오류 Error] 없는 번호입니다 / Invalid choice: !MENU_CHOICE!
echo   0 부터 11 사이에서 골라주세요 / Please pick 0 to 11.
pause
goto :MAIN_MENU


REM ================================================================
REM   [5] 계정 / 팀  (Account / Team)
REM ================================================================
:CAT_ACCOUNT
cls
echo.
echo ============================================================
echo   계정 / 팀 (Account / Team)
echo ============================================================
echo    1.  로그아웃        Logout
echo    2.  팀 목록         Teams
echo    3.  팀 전환         Switch Team
echo.
echo    0.  뒤로            Back
echo ============================================================
set "SUBC="
set /p "SUBC=   번호 입력 / Pick a number [0-3]: "
if "!SUBC!"=="0" goto :MAIN_MENU
if "!SUBC!"=="1" goto :F_LOGOUT
if "!SUBC!"=="2" goto :F_TEAMS
if "!SUBC!"=="3" goto :F_SWITCH
echo   [오류 Error] 없는 번호 / Invalid: !SUBC!
pause
goto :CAT_ACCOUNT


REM ================================================================
REM   [6] 프로젝트 / 배포  (Project / Deploys)
REM ================================================================
:CAT_PROJECT
cls
echo.
echo ============================================================
echo   프로젝트 / 배포 (Project / Deploys)
echo ============================================================
echo    1.  미리 실행       Dev Server        (내 컴퓨터에서 실행)
echo    2.  다시 배포       Redeploy          (마지막 빌드 재배포)
echo    3.  폴더 연결       Link Project      (이 폴더를 Vercel에 연결)
echo    4.  배포 목록       List Deployments
echo    5.  배포 상세       Inspect a Deploy
echo    6.  기록 보기       View Logs
echo    7.  브라우저 열기   Open in Browser
echo.
echo    0.  뒤로            Back
echo ============================================================
set "SUBC="
set /p "SUBC=   번호 입력 / Pick a number [0-7]: "
if "!SUBC!"=="0" goto :MAIN_MENU
if "!SUBC!"=="1" goto :F_DEV
if "!SUBC!"=="2" goto :F_REDEPLOY
if "!SUBC!"=="3" goto :F_LINK
if "!SUBC!"=="4" goto :F_LIST
if "!SUBC!"=="5" goto :F_INSPECT
if "!SUBC!"=="6" goto :F_LOGS
if "!SUBC!"=="7" goto :F_OPEN
echo   [오류 Error] 없는 번호 / Invalid: !SUBC!
pause
goto :CAT_PROJECT


REM ================================================================
REM   [7] 환경 변수  (Environment Variables)
REM ================================================================
:CAT_ENV
cls
echo.
echo ============================================================
echo   환경 변수 (Environment Variables)
echo   API 키 같은 비밀값을 Vercel에 저장합니다.
echo ============================================================
echo    1.  변수 목록       List Env Variables
echo    2.  변수 추가       Add Env Variable
echo    3.  변수 삭제       Remove Env Variable
echo    4.  변수 내려받기   Pull Env to .env
echo.
echo    0.  뒤로            Back
echo ============================================================
set "SUBC="
set /p "SUBC=   번호 입력 / Pick a number [0-4]: "
if "!SUBC!"=="0" goto :MAIN_MENU
if "!SUBC!"=="1" goto :F_ENV_LS
if "!SUBC!"=="2" goto :F_ENV_ADD
if "!SUBC!"=="3" goto :F_ENV_RM
if "!SUBC!"=="4" goto :F_ENV_PULL
echo   [오류 Error] 없는 번호 / Invalid: !SUBC!
pause
goto :CAT_ENV


REM ================================================================
REM   [8] 도메인 / 주소  (Domains / Address)
REM ================================================================
:CAT_DOMAIN
cls
echo.
echo ============================================================
echo   도메인 / 주소 (Domains / Address)
echo ============================================================
echo    1.  도메인 목록     List Domains
echo    2.  도메인 추가     Add Domain
echo    3.  도메인 삭제     Remove Domain
echo    4.  DNS 기록        DNS Records
echo    5.  사용자 주소     Alias            (배포에 맞춤 주소 달기)
echo.
echo    0.  뒤로            Back
echo ============================================================
set "SUBC="
set /p "SUBC=   번호 입력 / Pick a number [0-5]: "
if "!SUBC!"=="0" goto :MAIN_MENU
if "!SUBC!"=="1" goto :F_DOMAINS_LS
if "!SUBC!"=="2" goto :F_DOMAINS_ADD
if "!SUBC!"=="3" goto :F_DOMAINS_RM
if "!SUBC!"=="4" goto :F_DNS
if "!SUBC!"=="5" goto :F_ALIAS
echo   [오류 Error] 없는 번호 / Invalid: !SUBC!
pause
goto :CAT_DOMAIN


REM ================================================================
REM   [9] 고급 기능  (Advanced)
REM ================================================================
:CAT_ADVANCED
cls
echo.
echo ============================================================
echo   고급 기능 (Advanced)
echo ============================================================
echo    1.  공개로 승격     Promote Deploy    (미리보기 -^> 진짜 공개)
echo    2.  되돌리기        Rollback Deploy   (이전 버전으로)
echo    3.  배포 삭제       Remove Deploy
echo    4.  설정 받기       Pull Project Settings
echo    5.  새 프로젝트     Init New Project  (템플릿에서)
echo.
echo    0.  뒤로            Back
echo ============================================================
set "SUBC="
set /p "SUBC=   번호 입력 / Pick a number [0-5]: "
if "!SUBC!"=="0" goto :MAIN_MENU
if "!SUBC!"=="1" goto :F_PROMOTE
if "!SUBC!"=="2" goto :F_ROLLBACK
if "!SUBC!"=="3" goto :F_REMOVE
if "!SUBC!"=="4" goto :F_PULL
if "!SUBC!"=="5" goto :F_INIT
echo   [오류 Error] 없는 번호 / Invalid: !SUBC!
pause
goto :CAT_ADVANCED


REM ================================================================
REM   [10] 도구  (Tools)
REM ================================================================
:CAT_TOOLS
cls
echo.
echo ============================================================
echo   도구 (Tools)
echo ============================================================
echo    1.  버전 확인       Version Check
echo    2.  업데이트        Update Vercel CLI
echo    3.  도움말          Help (all commands)
echo.
echo    0.  뒤로            Back
echo ============================================================
set "SUBC="
set /p "SUBC=   번호 입력 / Pick a number [0-3]: "
if "!SUBC!"=="0" goto :MAIN_MENU
if "!SUBC!"=="1" goto :F_VERSION
if "!SUBC!"=="2" goto :F_UPDATE
if "!SUBC!"=="3" goto :F_HELP
echo   [오류 Error] 없는 번호 / Invalid: !SUBC!
pause
goto :CAT_TOOLS


REM ================================================================
REM   자주 쓰는 것 / QUICK ACTIONS
REM ================================================================
:F_DEPLOY_PREVIEW
cls
echo.
echo   === 미리보기 배포 / Deploy (Preview) ===
echo   임시 주소로 올립니다. 진짜 사이트는 그대로라 안전합니다.
echo   (Sends your project to Vercel as a safe preview.)
echo.
call vercel
echo.
pause
goto :MAIN_MENU

:F_DEPLOY_PROD
cls
echo.
echo   === 진짜 공개 배포 / Deploy (Production) ===
echo   * 주의: 방문자가 바로 보는 진짜 사이트로 올립니다.
echo   (Warning: this publishes to your LIVE site.)
echo.
set "CONFIRM_PROD="
set /p "CONFIRM_PROD=   정말 공개하려면 YES 입력 (대소문자 무관) / Type YES to publish: "
if /i not "!CONFIRM_PROD!"=="YES" goto :PROD_CANCEL
call vercel --prod
echo.
pause
goto :MAIN_MENU
:PROD_CANCEL
echo.
echo   취소했습니다. (YES 라고 입력해야 진행) / Cancelled (type YES to proceed).
echo.
pause
goto :MAIN_MENU

:F_LOGIN
cls
echo.
echo   === 로그인 / Login ===
echo   브라우저가 열리면 로그인/허용 하세요. (Sign in via browser.)
echo.
call vercel login
echo.
pause
goto :MAIN_MENU

:F_WHOAMI
cls
echo.
echo   === 내 계정 확인 / Who Am I ===
echo   지금 로그인된 계정을 보여줍니다. (Shows your account.)
echo.
call vercel whoami
echo.
pause
goto :MAIN_MENU


REM ================================================================
REM   계정 / ACCOUNT
REM ================================================================
:F_LOGOUT
cls
echo.
echo   === 로그아웃 / Logout ===
echo.
call vercel logout
echo.
pause
goto :MAIN_MENU

:F_TEAMS
cls
echo.
echo   === 팀 목록 / Teams ===
echo.
call vercel teams ls
echo.
pause
goto :MAIN_MENU

:F_SWITCH
cls
echo.
echo   === 팀 전환 / Switch Team ===
echo.
call vercel switch
echo.
pause
goto :MAIN_MENU


REM ================================================================
REM   프로젝트 / 배포 / PROJECT
REM ================================================================
:F_DEV
cls
echo.
echo   === 미리 실행 / Dev Server (Local) ===
echo   내 컴퓨터에서 미리 실행합니다. 멈추려면 Ctrl+C.
echo   (Runs your project locally. Press Ctrl+C to stop.)
echo.
call vercel dev
echo.
pause
goto :MAIN_MENU

:F_REDEPLOY
cls
echo.
echo   === 다시 배포 / Redeploy ===
echo   다시 빌드해서 배포합니다. (Builds and deploys again.)
echo.
call vercel redeploy
echo.
pause
goto :MAIN_MENU

:F_LINK
cls
echo.
echo   === 폴더 연결 / Link Project ===
echo   이 폴더를 Vercel 프로젝트에 연결합니다. (Link this folder.)
echo.
call vercel link
echo.
pause
goto :MAIN_MENU

:F_LIST
cls
echo.
echo   === 배포 목록 / List Deployments ===
echo.
call vercel ls
echo.
pause
goto :MAIN_MENU

:F_INSPECT
cls
echo.
echo   === 배포 상세 / Inspect a Deploy ===
echo   배포 주소(URL)를 입력하세요. (Type the deploy URL.)
echo.
set "INSPECT_URL="
set /p "INSPECT_URL=   배포 URL (그냥 Enter=취소) / Deploy URL (Enter to skip): "
if "!INSPECT_URL!"=="" goto :MAIN_MENU
call vercel inspect !INSPECT_URL!
echo.
pause
goto :MAIN_MENU

:F_LOGS
cls
echo.
echo   === 기록 보기 / View Logs ===
echo   배포 주소(URL)를 입력하세요. (Type the deploy URL.)
echo.
set "LOG_URL="
set /p "LOG_URL=   배포 URL (그냥 Enter=취소) / Deploy URL (Enter to skip): "
if "!LOG_URL!"=="" goto :MAIN_MENU
call vercel logs !LOG_URL!
echo.
pause
goto :MAIN_MENU

:F_OPEN
cls
echo.
echo   === 브라우저 열기 / Open in Browser ===
echo   이 프로젝트의 Vercel 페이지를 엽니다. (Opens dashboard.)
echo.
call vercel open
echo.
pause
goto :MAIN_MENU


REM ================================================================
REM   환경 변수 / ENVIRONMENT VARIABLES
REM ================================================================
:F_ENV_LS
cls
echo.
echo   === 변수 목록 / List Environment Variables ===
echo.
call vercel env ls
echo.
pause
goto :MAIN_MENU

:F_ENV_ADD
cls
echo.
echo   === 변수 추가 / Add Environment Variable ===
echo   안내에 따라 새 변수를 추가하세요. (Follow the prompts.)
echo.
call vercel env add
echo.
pause
goto :MAIN_MENU

:F_ENV_RM
cls
echo.
echo   === 변수 삭제 / Remove Environment Variable ===
echo   안내에 따라 변수를 삭제하세요. (Follow the prompts.)
echo.
call vercel env rm
echo.
pause
goto :MAIN_MENU

:F_ENV_PULL
cls
echo.
echo   === 변수 내려받기 / Pull Env to .env File ===
echo   환경변수를 .env 파일로 내려받습니다. (Downloads to .env.)
echo.
call vercel env pull
echo.
pause
goto :MAIN_MENU


REM ================================================================
REM   도메인 / DOMAINS
REM ================================================================
:F_DOMAINS_LS
cls
echo.
echo   === 도메인 목록 / List Domains ===
echo.
call vercel domains ls
echo.
pause
goto :MAIN_MENU

:F_DOMAINS_ADD
cls
echo.
echo   === 도메인 추가 / Add Domain ===
echo   추가할 도메인 이름을 입력하세요. (Type the domain name.)
echo.
set "NEW_DOMAIN="
set /p "NEW_DOMAIN=   도메인 (그냥 Enter=취소) / Domain (Enter to skip): "
if "!NEW_DOMAIN!"=="" goto :MAIN_MENU
call vercel domains add !NEW_DOMAIN!
echo.
pause
goto :MAIN_MENU

:F_DOMAINS_RM
cls
echo.
echo   === 도메인 삭제 / Remove Domain ===
echo   삭제할 도메인 이름을 입력하세요. (Type the domain name.)
echo.
set "RM_DOMAIN="
set /p "RM_DOMAIN=   도메인 (그냥 Enter=취소) / Domain (Enter to skip): "
if "!RM_DOMAIN!"=="" goto :MAIN_MENU
call vercel domains rm !RM_DOMAIN!
echo.
pause
goto :MAIN_MENU

:F_DNS
cls
echo.
echo   === DNS 기록 / DNS Records ===
echo   도메인의 DNS 기록을 보여줍니다. (Shows DNS records.)
echo.
set "DNS_DOMAIN="
set /p "DNS_DOMAIN=   도메인 (그냥 Enter=취소) / Domain (Enter to skip): "
if "!DNS_DOMAIN!"=="" goto :MAIN_MENU
call vercel dns ls !DNS_DOMAIN!
echo.
pause
goto :MAIN_MENU

:F_ALIAS
cls
echo.
echo   === 사용자 주소 / Alias (Custom URL) ===
echo   배포에 맞춤 주소를 답니다. (Give a custom URL to a deploy.)
echo   사용법(Usage): vercel alias [deploy-url] [custom-domain]
echo.
set "ALIAS_SRC="
set /p "ALIAS_SRC=   배포 URL / Deploy URL: "
if "!ALIAS_SRC!"=="" goto :MAIN_MENU
set "ALIAS_DST="
set /p "ALIAS_DST=   맞춤 주소 / Custom domain: "
if "!ALIAS_DST!"=="" goto :MAIN_MENU
call vercel alias !ALIAS_SRC! !ALIAS_DST!
echo.
pause
goto :MAIN_MENU


REM ================================================================
REM   고급 / ADVANCED
REM ================================================================
:F_PROMOTE
cls
echo.
echo   === 공개로 승격 / Promote Deploy ===
echo   미리보기 배포를 진짜 공개로 올립니다. 배포 URL 입력.
echo   (Move a preview deploy to production. Type the URL.)
echo.
set "PROMO_URL="
set /p "PROMO_URL=   배포 URL (그냥 Enter=취소) / Deploy URL (Enter to skip): "
if "!PROMO_URL!"=="" goto :MAIN_MENU
call vercel promote !PROMO_URL!
echo.
pause
goto :MAIN_MENU

:F_ROLLBACK
cls
echo.
echo   === 되돌리기 / Rollback Deploy ===
echo   이전 배포로 되돌립니다. 되돌릴 배포 URL 입력.
echo   (Go back to an older deployment. Type the URL.)
echo.
set "ROLL_URL="
set /p "ROLL_URL=   배포 URL (그냥 Enter=취소) / Deploy URL (Enter to skip): "
if "!ROLL_URL!"=="" goto :MAIN_MENU
call vercel rollback !ROLL_URL!
echo.
pause
goto :MAIN_MENU

:F_REMOVE
cls
echo.
echo   === 배포 삭제 / Remove Deploy ===
echo   배포를 삭제합니다. 배포 URL 입력. (Delete a deployment.)
echo.
set "DEL_URL="
set /p "DEL_URL=   배포 URL (그냥 Enter=취소) / Deploy URL (Enter to skip): "
if "!DEL_URL!"=="" goto :MAIN_MENU
call vercel remove !DEL_URL!
echo.
pause
goto :MAIN_MENU

:F_PULL
cls
echo.
echo   === 설정 받기 / Pull Project Settings ===
echo   프로젝트 설정/환경변수를 내려받습니다. (Downloads settings.)
echo.
call vercel pull
echo.
pause
goto :MAIN_MENU

:F_INIT
cls
echo.
echo   === 새 프로젝트 / Init New Project ===
echo   Vercel 템플릿으로 새 프로젝트를 시작합니다. (From template.)
echo.
call vercel init
echo.
pause
goto :MAIN_MENU


REM ================================================================
REM   도구 / TOOLS
REM ================================================================
:F_VERSION
cls
echo.
echo   === 버전 확인 / Version Check ===
echo.
set "VERCEL_VER="
for /f "tokens=*" %%v in ('vercel --version 2^>nul') do set "VERCEL_VER=%%v"
echo   Vercel CLI : !VERCEL_VER!
set "NODE_VER="
for /f "tokens=*" %%v in ('node -e "process.stdout.write(process.version)" 2^>nul') do set "NODE_VER=%%v"
echo   Node.js    : !NODE_VER!
set "NPM_VER="
for /f "tokens=*" %%v in ('npm -v 2^>nul') do set "NPM_VER=%%v"
echo   npm        : v!NPM_VER!
echo.
pause
goto :MAIN_MENU

:F_UPDATE
cls
echo.
echo   === 업데이트 / Update Vercel CLI ===
echo   최신 버전으로 업데이트합니다 ... (Updating to newest ...)
echo.
call npm install -g vercel@latest
echo.
set "VERCEL_VER="
for /f "tokens=*" %%v in ('vercel --version 2^>nul') do set "VERCEL_VER=%%v"
echo   업데이트 완료 / Updated to: !VERCEL_VER!
echo.
pause
goto :MAIN_MENU

:F_HELP
cls
echo.
echo   === 도움말 / Help ===
echo.
call vercel help
echo.
pause
goto :MAIN_MENU


REM ================================================================
REM   끝내기 / EXIT
REM ================================================================
:EXIT_APP
echo.
echo   안녕히 가세요! / Goodbye! Thank you for using Vercel CLI.
echo.
endlocal
exit /b 0


REM ================================================================
REM   오류 처리 / ERROR HANDLER
REM ================================================================
:ERR_NOT_INSTALLED
echo.
echo ============================================================
echo   [오류 Error] Vercel CLI 가 설치되어 있지 않습니다!
echo               Vercel CLI is not installed!
echo ============================================================
echo.
echo   먼저 시작하기.bat (또는 INSTALL.bat) 을 실행하세요.
echo   Please run 시작하기.bat (or INSTALL.bat) first.
echo.
pause
endlocal
exit /b 1
