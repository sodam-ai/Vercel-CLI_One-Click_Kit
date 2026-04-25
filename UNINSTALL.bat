@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion
title Vercel CLI - Uninstaller

REM ================================================================
REM   Vercel CLI - Safe Uninstaller
REM   Removes Vercel CLI and cleans up config files
REM   Encoding: UTF-8 No BOM, CRLF
REM ================================================================

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

REM === Add npm global bin to PATH ===
set "NPM_PREFIX="
for /f "tokens=*" %%p in ('npm config get prefix 2^>nul') do set "NPM_PREFIX=%%p"
if not "!NPM_PREFIX!"=="" set "PATH=!NPM_PREFIX!;!PATH!"

echo.
echo ============================================================
echo   Vercel CLI - Safe Uninstaller
echo ============================================================
echo.

REM === Check if installed ===
set "VERCEL_VER="
where vercel >nul 2>&1
if !ERRORLEVEL! NEQ 0 goto :NOT_FOUND

for /f "tokens=*" %%v in ('vercel --version 2^>nul') do set "VERCEL_VER=%%v"
echo   Found: Vercel CLI !VERCEL_VER!
echo.
echo   This will remove:
echo     1. Vercel CLI (npm global package)
echo     2. Vercel config folder  (~/.vercel)
echo     3. Local .vercel folder  (in this folder only)
echo.
echo   WARNING: This cannot be undone!
echo.

set "CONFIRM="
set /p "CONFIRM=   Type YES to uninstall: "
if /i "!CONFIRM!" NEQ "YES" goto :CANCELLED

echo.

REM ================================================================
REM   STEP 1/4  Logout first (ignore errors if not logged in)
REM ================================================================
echo [Step 1/4] Logging out ...
call vercel logout >nul 2>&1
echo           Done

REM ================================================================
REM   STEP 2/4  Uninstall npm package
REM ================================================================
echo.
echo [Step 2/4] Removing Vercel CLI package ...
echo           Running: npm uninstall -g vercel
echo.

call npm uninstall -g vercel
if !ERRORLEVEL! NEQ 0 goto :ERR_UNINSTALL

echo.
echo           Package removed [OK]

REM ================================================================
REM   STEP 3/4  Remove global config (~/.vercel)
REM ================================================================
echo.
echo [Step 3/4] Removing Vercel config folder ...

set "VERCEL_CFG=%USERPROFILE%\.vercel"

if not exist "!VERCEL_CFG!" goto :NO_GLOBAL_CFG

echo           Found: !VERCEL_CFG!
echo.

set "DEL_CFG="
set /p "DEL_CFG=           Delete config folder? [Y/N]: "
if /i "!DEL_CFG!" NEQ "Y" goto :SKIP_GLOBAL_CFG

rmdir /s /q "!VERCEL_CFG!" 2>nul
echo           Removed !VERCEL_CFG! [OK]
goto :STEP4

:NO_GLOBAL_CFG
echo           No config folder found [SKIP]
goto :STEP4

:SKIP_GLOBAL_CFG
echo           Keeping config folder [SKIP]

REM ================================================================
REM   STEP 4/4  Remove local .vercel folder
REM ================================================================
:STEP4
echo.
echo [Step 4/4] Removing local .vercel folder ...

if not exist "%SCRIPT_DIR%\.vercel" goto :NO_LOCAL_CFG

echo           Found: %SCRIPT_DIR%\.vercel
echo.

set "DEL_LOCAL="
set /p "DEL_LOCAL=           Delete local .vercel folder? [Y/N]: "
if /i "!DEL_LOCAL!" NEQ "Y" goto :SKIP_LOCAL_CFG

rmdir /s /q "%SCRIPT_DIR%\.vercel" 2>nul
echo           Removed [OK]
goto :UNINSTALL_DONE

:NO_LOCAL_CFG
echo           No local .vercel folder found [SKIP]
goto :UNINSTALL_DONE

:SKIP_LOCAL_CFG
echo           Keeping local .vercel folder [SKIP]

:UNINSTALL_DONE
echo.
echo ============================================================
echo   UNINSTALL COMPLETE
echo ============================================================
echo.
echo   Vercel CLI has been removed.
echo   To install again, run INSTALL.bat.
echo.
pause
endlocal
exit /b 0


REM ================================================================
REM   ERROR / CANCEL HANDLERS
REM ================================================================
:NOT_FOUND
echo   Vercel CLI is not installed. Nothing to remove.
echo.
pause
endlocal
exit /b 0

:CANCELLED
echo.
echo   Uninstall cancelled. Nothing was changed.
echo.
pause
endlocal
exit /b 0

:ERR_UNINSTALL
echo.
echo   [ERROR] npm uninstall -g vercel failed!
echo.
echo   Try: Right-click UNINSTALL.bat and pick 'Run as Administrator'
echo.
pause
endlocal
exit /b 3