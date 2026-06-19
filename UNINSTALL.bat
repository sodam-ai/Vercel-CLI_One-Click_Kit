@echo off
chcp 949 >nul
setlocal EnableDelayedExpansion
title Vercel CLI - 제거 (Uninstaller)

REM ================================================================
REM   Vercel CLI - 안전 제거 / Safe Uninstaller
REM   Vercel CLI 제거 + 설정 파일 정리 / Removes CLI and cleans config
REM   인코딩: CP949 (한글) + CRLF, chcp 949
REM   ** 관리자 권한 필요 없음 / No admin needed **
REM   ** 내가 만든 코드/파일은 지우지 않습니다 / Your own files are kept **
REM ================================================================

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

REM === npm 전역 폴더를 PATH에 / Add npm global bin to PATH ===
set "NPM_PREFIX="
for /f "tokens=*" %%p in ('npm config get prefix 2^>nul') do set "NPM_PREFIX=%%p"
if not "!NPM_PREFIX!"=="" set "PATH=!NPM_PREFIX!;!PATH!"

echo.
echo ============================================================
echo   Vercel CLI - 안전 제거 / Safe Uninstaller
echo ============================================================
echo.

REM === 설치 확인 / Check if installed ===
set "VERCEL_VER="
where vercel >nul 2>&1
if !ERRORLEVEL! NEQ 0 goto :NOT_FOUND

for /f "tokens=*" %%v in ('vercel --version 2^>nul') do set "VERCEL_VER=%%v"
echo   찾음 / Found: Vercel CLI !VERCEL_VER!
echo.
echo   이것들을 지웁니다 / This will remove:
echo     1. Vercel CLI (npm 전역 패키지 / global package)
echo     2. Vercel 설정 폴더 / config folder  (~/.vercel)
echo     3. 이 폴더의 .vercel / local .vercel (in this folder only)
echo.
echo   [주의 Warning] 되돌릴 수 없습니다 / This cannot be undone!
echo   (내가 만든 코드/파일은 안전합니다 / Your own files are safe.)
echo.

set "CONFIRM="
set /p "CONFIRM=   제거하려면 YES 입력 (대소문자 무관) / Type YES to uninstall: "
if /i "!CONFIRM!" NEQ "YES" goto :CANCELLED

echo.

REM ================================================================
REM   1/4  로그아웃 / Logout first (오류 무시 / ignore errors)
REM ================================================================
echo [1/4] 로그아웃 / Logging out ...
call vercel logout >nul 2>&1
echo        완료 / Done

REM ================================================================
REM   2/4  패키지 제거 / Uninstall npm package
REM ================================================================
echo.
echo [2/4] Vercel CLI 제거 중 / Removing Vercel CLI package ...
echo        실행 / Running: npm uninstall -g vercel
echo.

call npm uninstall -g vercel
if !ERRORLEVEL! NEQ 0 goto :ERR_UNINSTALL

echo.
echo        패키지 제거됨 / Package removed [OK]

REM ================================================================
REM   3/4  전역 설정 제거 / Remove global config (~/.vercel)
REM ================================================================
echo.
echo [3/4] Vercel 설정 폴더 제거 / Removing config folder ...

set "VERCEL_CFG=%USERPROFILE%\.vercel"

if not exist "!VERCEL_CFG!" goto :NO_GLOBAL_CFG

echo        찾음 / Found: !VERCEL_CFG!
echo.

echo        설정 폴더도 삭제할까요? / Delete config folder too?
echo        - 5초 안에 [N] 을 누르면 남겨둡니다.
echo        - 그냥 두면 5초 뒤 깨끗이 삭제합니다.
echo          (Press [N] within 5s to keep; otherwise it is removed.)
choice /c YN /n /t 5 /d Y >nul
if errorlevel 2 goto :SKIP_GLOBAL_CFG

rmdir /s /q "!VERCEL_CFG!" 2>nul
echo        삭제됨 / Removed !VERCEL_CFG! [OK]
goto :STEP4

:NO_GLOBAL_CFG
echo        설정 폴더 없음 / No config folder found [SKIP]
goto :STEP4

:SKIP_GLOBAL_CFG
echo        설정 폴더 유지 / Keeping config folder [SKIP]

REM ================================================================
REM   4/4  이 폴더의 .vercel 제거 / Remove local .vercel folder
REM ================================================================
:STEP4
echo.
echo [4/4] 이 폴더의 .vercel 제거 / Removing local .vercel folder ...

if not exist "%SCRIPT_DIR%\.vercel" goto :NO_LOCAL_CFG

echo        찾음 / Found: %SCRIPT_DIR%\.vercel
echo.

echo        이 폴더의 .vercel 도 삭제할까요? / Delete local .vercel too?
echo        - 5초 안에 [N] 을 누르면 남겨둡니다.
echo        - 그냥 두면 5초 뒤 삭제합니다.
echo          (Press [N] within 5s to keep; otherwise it is removed.)
choice /c YN /n /t 5 /d Y >nul
if errorlevel 2 goto :SKIP_LOCAL_CFG

rmdir /s /q "%SCRIPT_DIR%\.vercel" 2>nul
echo        삭제됨 / Removed [OK]
goto :UNINSTALL_DONE

:NO_LOCAL_CFG
echo        없음 / No local .vercel folder found [SKIP]
goto :UNINSTALL_DONE

:SKIP_LOCAL_CFG
echo        유지 / Keeping local .vercel folder [SKIP]

:UNINSTALL_DONE
echo.
echo ============================================================
echo   제거 완료 / UNINSTALL COMPLETE
echo ============================================================
echo.
echo   Vercel CLI 가 제거되었습니다 / Vercel CLI has been removed.
echo   다시 설치하려면 INSTALL.bat / To install again, run INSTALL.bat.
echo.
pause
endlocal
exit /b 0


REM ================================================================
REM   오류 / 취소 처리 / ERROR / CANCEL HANDLERS
REM ================================================================
:NOT_FOUND
echo   Vercel CLI 가 설치되어 있지 않습니다. 지울 것이 없습니다.
echo   Vercel CLI is not installed. Nothing to remove.
echo.
pause
endlocal
exit /b 0

:CANCELLED
echo.
echo   제거를 취소했습니다. 아무것도 바뀌지 않았습니다.
echo   Uninstall cancelled. Nothing was changed.
echo.
pause
endlocal
exit /b 0

:ERR_UNINSTALL
echo.
echo   [문제 Problem] npm uninstall -g vercel 실패 / failed!
echo   (드물게 권한 오류면, 그때만 우클릭 -^> 관리자 권한으로 실행)
echo   (Only if a rare permission error: right-click -^> Run as administrator)
echo.
pause
endlocal
exit /b 3
