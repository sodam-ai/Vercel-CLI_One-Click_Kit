@echo off
chcp 949 >nul
setlocal EnableDelayedExpansion
title Vercel CLI - 설치 (Installer)

REM ================================================================
REM   Vercel CLI - 원클릭 설치 / One-Click Installer
REM   GitHub : https://github.com/vercel/vercel
REM   필요(Need): Node.js 18 이상 / 18 or newer
REM   인코딩: CP949 (한글) + CRLF, chcp 949
REM
REM   ** 관리자 권한 필요 없음 / No admin needed **
REM     Vercel은 사용자 폴더(%APPDATA%\npm)에 설치되어
REM     관리자 허용(UAC) 창이 뜨지 않습니다.
REM ================================================================

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

echo.
echo ============================================================
echo   Vercel CLI - 원클릭 설치 / One-Click Installer
echo   https://vercel.com/docs/cli
echo ============================================================
echo   폴더(Folder) : %SCRIPT_DIR%
echo   관리자 권한 필요 없음 / No admin needed
echo ============================================================
echo.
echo   검은 창이 영어로 떠도 정상입니다. 닫지 말고 기다리세요.
echo   (A black window is normal. Please wait, do not close it.)
echo.

REM ================================================================
REM   1/6  인터넷 확인 / Internet check
REM ================================================================
echo [1/6] 인터넷 확인 중 / Checking internet ...

ping -n 1 -w 3000 8.8.8.8 >nul 2>&1
if !ERRORLEVEL! NEQ 0 goto :ERR_NO_NET

echo        인터넷 좋음 / Internet [OK]

REM ================================================================
REM   2/6  Node.js 확인 / Node.js check (>= 18)
REM ================================================================
echo.
echo [2/6] Node.js 찾는 중 / Looking for Node.js ...

where node >nul 2>&1
if !ERRORLEVEL! NEQ 0 goto :ERR_NO_NODE

set "NODE_VER="
for /f "tokens=*" %%v in ('node -e "process.stdout.write(process.version)" 2^>nul') do set "NODE_VER=%%v"

set "NODE_MAJOR="
for /f "tokens=1 delims=." %%n in ("!NODE_VER:v=!") do set "NODE_MAJOR=%%n"

if !NODE_MAJOR! LSS 18 goto :ERR_OLD_NODE

echo        Node.js !NODE_VER! [OK]

REM ================================================================
REM   3/6  npm 확인 / npm check
REM ================================================================
echo.
echo [3/6] npm 찾는 중 / Looking for npm ...

where npm >nul 2>&1
if !ERRORLEVEL! NEQ 0 goto :ERR_NO_NPM

set "NPM_VER="
for /f "tokens=*" %%v in ('npm -v 2^>nul') do set "NPM_VER=%%v"
echo        npm v!NPM_VER! [OK]

REM ================================================================
REM   4/6  npm 전역 폴더를 PATH에 / Add npm global bin to PATH
REM ================================================================
echo.
echo [4/6] 설치 경로 준비 / Setting up npm global path ...

set "NPM_PREFIX="
for /f "tokens=*" %%p in ('npm config get prefix 2^>nul') do set "NPM_PREFIX=%%p"

if "!NPM_PREFIX!"=="" goto :SKIP_PATH_FIX

echo !PATH! | findstr /i /c:"!NPM_PREFIX!" >nul 2>&1
if !ERRORLEVEL! EQU 0 goto :PATH_ALREADY_OK

set "PATH=!NPM_PREFIX!;!PATH!"
echo        PATH에 추가함 / Added !NPM_PREFIX! [OK]
goto :STEP5_CHECK

:PATH_ALREADY_OK
echo        PATH 이미 준비됨 / already in PATH [OK]
goto :STEP5_CHECK

:SKIP_PATH_FIX
echo        [주의 Warning] npm 폴더를 못 찾아 건너뜀 / skip

REM ================================================================
REM   5/6  기존 확인 / 설치 / Check existing / Install
REM ================================================================
:STEP5_CHECK
echo.
echo [5/6] Vercel CLI 설치 중 / Installing Vercel CLI ...

set "VERCEL_VER="
where vercel >nul 2>&1
if !ERRORLEVEL! NEQ 0 goto :DO_INSTALL

for /f "tokens=*" %%v in ('vercel --version 2^>nul') do set "VERCEL_VER=%%v"
echo        이미 설치되어 있어요. 그대로 바로 쓸 수 있습니다.
echo        (Already installed - you can use it right away.)
echo        업데이트는 RUN.bat 에서: [10] 도구 -^> [2] 업데이트
echo        (To update, use RUN.bat: [10] Tools -^> [2] Update.)
goto :INSTALL_DONE

:DO_INSTALL
echo.
echo        실행 / Running: npm install -g vercel
echo        3~10분 걸릴 수 있어요. 창을 닫지 마세요.
echo        (Can take 3-10 minutes. Do not close this window.)
echo.

call npm install -g vercel
if !ERRORLEVEL! NEQ 0 goto :ERR_INSTALL_FAIL

echo.
echo        설치 끝 / Install done [OK]

REM ================================================================
REM   6/6  확인 / Verify
REM ================================================================
echo.
echo [6/6] 설치 확인 / Checking installation ...

set "NPM_PREFIX="
for /f "tokens=*" %%p in ('npm config get prefix 2^>nul') do set "NPM_PREFIX=%%p"
if not "!NPM_PREFIX!"=="" set "PATH=!NPM_PREFIX!;!PATH!"

where vercel >nul 2>&1
if !ERRORLEVEL! NEQ 0 goto :ERR_VERIFY_FAIL

set "VERCEL_VER="
for /f "tokens=*" %%v in ('vercel --version 2^>nul') do set "VERCEL_VER=%%v"
echo        Vercel CLI !VERCEL_VER! [OK]

:INSTALL_DONE
echo.
echo ============================================================
echo   설치 완료 / INSTALLATION COMPLETE
echo ============================================================
echo   Vercel CLI : !VERCEL_VER!
echo   Node.js    : !NODE_VER!
echo   npm        : v!NPM_VER!
echo ============================================================
echo.
echo   다음 / What to do next:
echo     1. 시작하기.bat 더블클릭 (한국어 안내) / double-click 시작하기.bat
echo     2. 또는 RUN.bat 실행 후 5(로그인) / or RUN.bat then 5 (Login)
echo     3. 그다음 1(미리보기 배포) / then 1 (Deploy Preview)
echo.
pause
endlocal
exit /b 0


REM ================================================================
REM   오류 처리 / ERROR HANDLERS
REM ================================================================
:ERR_NO_NET
echo.
echo   [오류 Error] 인터넷 연결이 없습니다 / No internet connection!
echo   인터넷을 확인하고 다시 시도하세요 / Check internet and retry.
echo.
pause
endlocal
exit /b 1

:ERR_NO_NODE
echo.
echo   [문제 Problem] Node.js 가 없습니다 / Node.js is not installed!
echo.
echo   해결(How to fix):
echo     1. https://nodejs.org 접속 / open the site
echo     2. 초록색 LTS 버튼으로 받기 / download the green LTS button
echo     3. 설치 후 이 창 닫고 다시 실행 / install, then run again
echo.
echo   (더 쉬운 방법: 시작하기.bat 의 [1] 설치하기 가 자동 안내합니다.)
echo.
pause
endlocal
exit /b 2

:ERR_OLD_NODE
echo.
echo   [문제 Problem] Node.js !NODE_VER! 가 너무 오래됨 / too old!
echo   18 이상이 필요합니다 / You need Node.js 18 or newer.
echo   https://nodejs.org 에서 최신 LTS 설치 / install latest LTS.
echo.
pause
endlocal
exit /b 2

:ERR_NO_NPM
echo.
echo   [문제 Problem] npm 이 없습니다 / npm is not installed!
echo   Node.js 를 다시 설치하세요 / Reinstall Node.js from nodejs.org
echo.
pause
endlocal
exit /b 2

:ERR_INSTALL_FAIL
echo.
echo   [문제 Problem] 설치가 실패했습니다 / install failed!
echo.
echo   이렇게 해보세요 / Try these:
echo     1. 백신을 10분만 끄고 다시 / Pause antivirus 10 min, retry
echo     2. 인터넷(와이파이) 확인 / Check your internet
echo     3. npm cache clean --force 후 다시 / then retry
echo     4. (드물게 권한 오류 EACCES 면, 그때만 우클릭 -^> 관리자 권한)
echo        (Only if a rare EACCES/permission error: right-click -^> Run as administrator)
echo.
pause
endlocal
exit /b 3

:ERR_VERIFY_FAIL
echo.
echo   [알림 Info] 설치는 됐지만 이 창에서 vercel 을 못 찾습니다.
echo              Installed, but vercel not found in THIS window.
echo.
echo   해결(Fix): 이 창을 닫고 새 창에서 다시 실행하세요.
echo             Close this window, open a NEW one, then run again.
echo.
set "NPM_PREFIX="
for /f "tokens=*" %%p in ('npm config get prefix 2^>nul') do set "NPM_PREFIX=%%p"
echo   npm 전역 폴더 / npm global folder: !NPM_PREFIX!
echo.
pause
endlocal
exit /b 3
