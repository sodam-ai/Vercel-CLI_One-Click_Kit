@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion
title Vercel CLI - Installer

REM ================================================================
REM   Vercel CLI - One-Click Installer
REM   GitHub : https://github.com/vercel/vercel
REM   Docs   : https://vercel.com/docs/cli
REM   Need   : Node.js 18 or newer
REM   Encoding: UTF-8 No BOM, CRLF
REM ================================================================
REM
REM   [SAFE CODING RULES]
REM   - goto  : single-line if only, never in ( ) blocks
REM   - set /p: top level only, never in ( ) blocks
REM   - call  : always before npm/external commands
REM   - !VAR! : delayed expansion used everywhere
REM
REM ================================================================

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

echo.
echo ============================================================
echo   Vercel CLI - One-Click Installer
echo   https://vercel.com/docs/cli
echo ============================================================
echo   Folder : %SCRIPT_DIR%
echo ============================================================
echo.

REM ================================================================
REM   STEP 1/6  Internet check
REM ================================================================
echo [Step 1/6] Checking internet ...

ping -n 1 -w 3000 8.8.8.8 >nul 2>&1
if !ERRORLEVEL! NEQ 0 goto :ERR_NO_NET

echo           Internet [OK]

REM ================================================================
REM   STEP 2/6  Node.js check (>= 18)
REM ================================================================
echo.
echo [Step 2/6] Looking for Node.js ...

where node >nul 2>&1
if !ERRORLEVEL! NEQ 0 goto :ERR_NO_NODE

set "NODE_VER="
for /f "tokens=*" %%v in ('node -e "process.stdout.write(process.version)" 2^>nul') do set "NODE_VER=%%v"

set "NODE_MAJOR="
for /f "tokens=1 delims=." %%n in ("!NODE_VER:v=!") do set "NODE_MAJOR=%%n"

if !NODE_MAJOR! LSS 18 goto :ERR_OLD_NODE

echo           Node.js !NODE_VER! [OK]

REM ================================================================
REM   STEP 3/6  npm check
REM ================================================================
echo.
echo [Step 3/6] Looking for npm ...

where npm >nul 2>&1
if !ERRORLEVEL! NEQ 0 goto :ERR_NO_NPM

set "NPM_VER="
for /f "tokens=*" %%v in ('npm -v 2^>nul') do set "NPM_VER=%%v"
echo           npm v!NPM_VER! [OK]

REM ================================================================
REM   STEP 4/6  Add npm global bin to PATH (important fix!)
REM ================================================================
echo.
echo [Step 4/6] Setting up npm global path ...

set "NPM_PREFIX="
for /f "tokens=*" %%p in ('npm config get prefix 2^>nul') do set "NPM_PREFIX=%%p"

if "!NPM_PREFIX!"=="" goto :SKIP_PATH_FIX

echo !PATH! | findstr /i /c:"!NPM_PREFIX!" >nul 2>&1
if !ERRORLEVEL! EQU 0 goto :PATH_ALREADY_OK

set "PATH=!NPM_PREFIX!;!PATH!"
echo           Added !NPM_PREFIX! to PATH [OK]
goto :STEP5_CHECK

:PATH_ALREADY_OK
echo           npm global path already in PATH [OK]
goto :STEP5_CHECK

:SKIP_PATH_FIX
echo           [WARNING] Could not find npm prefix, skipping

REM ================================================================
REM   STEP 5/6  Check existing / Install
REM ================================================================
:STEP5_CHECK
echo.
echo [Step 5/6] Installing Vercel CLI ...

set "VERCEL_VER="
where vercel >nul 2>&1
if !ERRORLEVEL! NEQ 0 goto :DO_INSTALL

for /f "tokens=*" %%v in ('vercel --version 2^>nul') do set "VERCEL_VER=%%v"
echo           Found: Vercel CLI !VERCEL_VER!
echo.
echo           Already installed. Update or reinstall?
echo           [Y] Yes - update / reinstall
echo           [N] No  - skip
echo.

set "REINSTALL="
set /p "REINSTALL=           Your choice [Y/N]: "
if /i "!REINSTALL!" NEQ "Y" goto :INSTALL_DONE

:DO_INSTALL
echo.
echo           Running: npm install -g vercel
echo.

call npm install -g vercel
if !ERRORLEVEL! NEQ 0 goto :ERR_INSTALL_FAIL

echo.
echo           Install done [OK]

REM ================================================================
REM   STEP 6/6  Verify
REM ================================================================
echo.
echo [Step 6/6] Checking installation ...

REM Re-add npm prefix to PATH in case it changed
set "NPM_PREFIX="
for /f "tokens=*" %%p in ('npm config get prefix 2^>nul') do set "NPM_PREFIX=%%p"
if not "!NPM_PREFIX!"=="" set "PATH=!NPM_PREFIX!;!PATH!"

where vercel >nul 2>&1
if !ERRORLEVEL! NEQ 0 goto :ERR_VERIFY_FAIL

set "VERCEL_VER="
for /f "tokens=*" %%v in ('vercel --version 2^>nul') do set "VERCEL_VER=%%v"
echo           Vercel CLI !VERCEL_VER! [OK]

:INSTALL_DONE
echo.
echo ============================================================
echo   INSTALLATION COMPLETE
echo ============================================================
echo   Vercel CLI : !VERCEL_VER!
echo   Node.js    : !NODE_VER!
echo   npm        : v!NPM_VER!
echo ============================================================
echo.
echo   What to do next:
echo     1. Run RUN.bat to use Vercel CLI
echo     2. Pick [Login] to sign in
echo     3. Pick [Deploy] to publish your site
echo.
pause
endlocal
exit /b 0


REM ================================================================
REM   ERROR HANDLERS
REM ================================================================
:ERR_NO_NET
echo.
echo   [ERROR] No internet connection!
echo.
echo   Please check your internet and try again.
echo.
pause
endlocal
exit /b 1

:ERR_NO_NODE
echo.
echo   [ERROR] Node.js is not installed!
echo.
echo   Please download Node.js 18 or newer from:
echo   https://nodejs.org/
echo.
pause
endlocal
exit /b 2

:ERR_OLD_NODE
echo.
echo   [ERROR] Node.js !NODE_VER! is too old!
echo   You need Node.js 18 or newer.
echo.
echo   Please update from: https://nodejs.org/
echo.
pause
endlocal
exit /b 2

:ERR_NO_NPM
echo.
echo   [ERROR] npm is not installed!
echo   Please reinstall Node.js from https://nodejs.org/
echo.
pause
endlocal
exit /b 2

:ERR_INSTALL_FAIL
echo.
echo   [ERROR] npm install -g vercel failed!
echo.
echo   Try these fixes:
echo     1. Right-click INSTALL.bat and pick 'Run as Administrator'
echo     2. Run: npm cache clean --force
echo     3. Check your internet connection
echo.
pause
endlocal
exit /b 3

:ERR_VERIFY_FAIL
echo.
echo   [ERROR] vercel command not found after install!
echo.
echo   This means npm global folder is not in your PATH.
echo   Fix: Close ALL terminals, open a NEW one, then type:
echo     vercel --version
echo.
set "NPM_PREFIX="
for /f "tokens=*" %%p in ('npm config get prefix 2^>nul') do set "NPM_PREFIX=%%p"
echo   npm global folder: !NPM_PREFIX!
echo.
echo   To fix PATH permanently, run this in PowerShell (as Admin):
echo     [Environment]::SetEnvironmentVariable(
echo       'PATH',
echo       [Environment]::GetEnvironmentVariable('PATH','User') + ';!NPM_PREFIX!',
echo       'User'
echo     )
echo.
pause
endlocal
exit /b 3