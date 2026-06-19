@echo off
chcp 949 >nul
title Vercel CLI Kit - 시작하기 (Start Here)
cd /d "%~dp0"

REM ============================================
REM   한국어 안내 실행기 / Korean guide launcher.
REM   한국어 화면은 lib\start.ps1 에서 처리합니다.
REM   (All Korean UI lives in lib\start.ps1.)
REM   ** 관리자 권한 필요 없음 / No admin needed **
REM ============================================

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0lib\start.ps1"
if %errorlevel% NEQ 0 (
    echo.
    echo [!] 한국어 안내를 열지 못했습니다. / Could not open the Korean guide.
    echo     INSTALL.bat / RUN.bat / UNINSTALL.bat 을 직접 써도 됩니다.
    echo     You can still use INSTALL.bat / RUN.bat / UNINSTALL.bat directly.
    echo.
    pause
)
exit /b 0
