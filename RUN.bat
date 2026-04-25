@echo off
chcp 65001 >nul 2>&1
setlocal EnableDelayedExpansion
title Vercel CLI - Menu

REM ================================================================
REM   Vercel CLI - One-Click Runner (Full Menu)
REM   All Vercel CLI features in one easy menu
REM   Encoding: UTF-8 No BOM, CRLF
REM ================================================================

set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

REM === Add npm global bin to PATH ===
set "NPM_PREFIX="
for /f "tokens=*" %%p in ('npm config get prefix 2^>nul') do set "NPM_PREFIX=%%p"
if not "!NPM_PREFIX!"=="" set "PATH=!NPM_PREFIX!;!PATH!"

REM === Check vercel exists ===
where vercel >nul 2>&1
if !ERRORLEVEL! NEQ 0 goto :ERR_NOT_INSTALLED

set "VERCEL_VER="
for /f "tokens=*" %%v in ('vercel --version 2^>nul') do set "VERCEL_VER=%%v"

REM ================================================================
REM   MAIN MENU
REM ================================================================
:MAIN_MENU
cls
echo.
echo ============================================================
echo   Vercel CLI - Easy Menu
echo   Version : !VERCEL_VER!
echo   Folder  : %SCRIPT_DIR%
echo ============================================================
echo.
echo   --- Deploy and Run ---
echo    1. Deploy (Preview)
echo    2. Deploy (Production)
echo    3. Dev Server (run locally)
echo    4. Redeploy last build
echo.
echo   --- Account ---
echo    5. Login
echo    6. Logout
echo    7. Who Am I  (show my account)
echo    8. Teams     (list teams)
echo    9. Switch Team
echo.
echo   --- Project Info ---
echo   10. Link Project  (connect folder to Vercel)
echo   11. List Deployments
echo   12. Inspect a Deploy
echo   13. View Logs
echo   14. Open in Browser
echo.
echo   --- Environment Variables ---
echo   15. List Env Variables
echo   16. Add Env Variable
echo   17. Remove Env Variable
echo   18. Pull Env to .env file
echo.
echo   --- Domains ---
echo   19. List Domains
echo   20. Add Domain
echo   21. Remove Domain
echo.
echo   --- Advanced ---
echo   22. Promote Deploy  (move to production)
echo   23. Rollback Deploy (go back to old version)
echo   24. Remove Deploy   (delete a deployment)
echo   25. Pull Project Settings
echo   26. Init New Project (from template)
echo   27. Alias (custom URL for a deploy)
echo   28. DNS Records
echo.
echo   --- Tools ---
echo   29. Version Check
echo   30. Update Vercel CLI
echo   31. Help (all commands)
echo.
echo    0. Exit
echo.
echo ============================================================

set "MENU_CHOICE="
set /p "MENU_CHOICE=   Pick a number [0-31]: "

if "!MENU_CHOICE!"=="0" goto :EXIT_APP
if "!MENU_CHOICE!"=="1" goto :F_DEPLOY_PREVIEW
if "!MENU_CHOICE!"=="2" goto :F_DEPLOY_PROD
if "!MENU_CHOICE!"=="3" goto :F_DEV
if "!MENU_CHOICE!"=="4" goto :F_REDEPLOY
if "!MENU_CHOICE!"=="5" goto :F_LOGIN
if "!MENU_CHOICE!"=="6" goto :F_LOGOUT
if "!MENU_CHOICE!"=="7" goto :F_WHOAMI
if "!MENU_CHOICE!"=="8" goto :F_TEAMS
if "!MENU_CHOICE!"=="9" goto :F_SWITCH
if "!MENU_CHOICE!"=="10" goto :F_LINK
if "!MENU_CHOICE!"=="11" goto :F_LIST
if "!MENU_CHOICE!"=="12" goto :F_INSPECT
if "!MENU_CHOICE!"=="13" goto :F_LOGS
if "!MENU_CHOICE!"=="14" goto :F_OPEN
if "!MENU_CHOICE!"=="15" goto :F_ENV_LS
if "!MENU_CHOICE!"=="16" goto :F_ENV_ADD
if "!MENU_CHOICE!"=="17" goto :F_ENV_RM
if "!MENU_CHOICE!"=="18" goto :F_ENV_PULL
if "!MENU_CHOICE!"=="19" goto :F_DOMAINS_LS
if "!MENU_CHOICE!"=="20" goto :F_DOMAINS_ADD
if "!MENU_CHOICE!"=="21" goto :F_DOMAINS_RM
if "!MENU_CHOICE!"=="22" goto :F_PROMOTE
if "!MENU_CHOICE!"=="23" goto :F_ROLLBACK
if "!MENU_CHOICE!"=="24" goto :F_REMOVE
if "!MENU_CHOICE!"=="25" goto :F_PULL
if "!MENU_CHOICE!"=="26" goto :F_INIT
if "!MENU_CHOICE!"=="27" goto :F_ALIAS
if "!MENU_CHOICE!"=="28" goto :F_DNS
if "!MENU_CHOICE!"=="29" goto :F_VERSION
if "!MENU_CHOICE!"=="30" goto :F_UPDATE
if "!MENU_CHOICE!"=="31" goto :F_HELP

echo.
echo   [ERROR] Invalid choice: !MENU_CHOICE!
echo   Please pick a number from 0 to 31.
pause
goto :MAIN_MENU


REM ================================================================
REM   DEPLOY AND RUN
REM ================================================================
:F_DEPLOY_PREVIEW
cls
echo.
echo   === Deploy (Preview) ===
echo   This sends your project to Vercel as a preview.
echo.
call vercel
echo.
pause
goto :MAIN_MENU

:F_DEPLOY_PROD
cls
echo.
echo   === Deploy (Production) ===
echo   This sends your project to Vercel as the LIVE site.
echo.
call vercel --prod
echo.
pause
goto :MAIN_MENU

:F_DEV
cls
echo.
echo   === Dev Server (Local) ===
echo   This runs your project on your computer.
echo   Press Ctrl+C to stop the server.
echo.
call vercel dev
echo.
pause
goto :MAIN_MENU

:F_REDEPLOY
cls
echo.
echo   === Redeploy ===
echo   This builds and deploys your project again.
echo.
call vercel redeploy
echo.
pause
goto :MAIN_MENU


REM ================================================================
REM   ACCOUNT
REM ================================================================
:F_LOGIN
cls
echo.
echo   === Login ===
echo   Sign in to your Vercel account.
echo.
call vercel login
echo.
pause
goto :MAIN_MENU

:F_LOGOUT
cls
echo.
echo   === Logout ===
echo   Sign out of your Vercel account.
echo.
call vercel logout
echo.
pause
goto :MAIN_MENU

:F_WHOAMI
cls
echo.
echo   === Who Am I ===
echo   Shows which account you are logged in as.
echo.
call vercel whoami
echo.
pause
goto :MAIN_MENU

:F_TEAMS
cls
echo.
echo   === Teams ===
echo   Shows all your teams on Vercel.
echo.
call vercel teams ls
echo.
pause
goto :MAIN_MENU

:F_SWITCH
cls
echo.
echo   === Switch Team ===
echo   Change to a different team.
echo.
call vercel switch
echo.
pause
goto :MAIN_MENU


REM ================================================================
REM   PROJECT INFO
REM ================================================================
:F_LINK
cls
echo.
echo   === Link Project ===
echo   Connect this folder to a Vercel project.
echo.
call vercel link
echo.
pause
goto :MAIN_MENU

:F_LIST
cls
echo.
echo   === List Deployments ===
echo   Shows all recent deployments.
echo.
call vercel ls
echo.
pause
goto :MAIN_MENU

:F_INSPECT
cls
echo.
echo   === Inspect a Deploy ===
echo   Type the deploy URL to see details.
echo.

set "INSPECT_URL="
set /p "INSPECT_URL=   Deploy URL (or press Enter to skip): "
if "!INSPECT_URL!"=="" goto :MAIN_MENU

call vercel inspect !INSPECT_URL!
echo.
pause
goto :MAIN_MENU

:F_LOGS
cls
echo.
echo   === View Logs ===
echo   Type the deploy URL to see its logs.
echo.

set "LOG_URL="
set /p "LOG_URL=   Deploy URL (or press Enter to skip): "
if "!LOG_URL!"=="" goto :MAIN_MENU

call vercel logs !LOG_URL!
echo.
pause
goto :MAIN_MENU

:F_OPEN
cls
echo.
echo   === Open in Browser ===
echo   Opens the Vercel dashboard for this project.
echo.
call vercel open
echo.
pause
goto :MAIN_MENU


REM ================================================================
REM   ENVIRONMENT VARIABLES
REM ================================================================
:F_ENV_LS
cls
echo.
echo   === List Environment Variables ===
echo.
call vercel env ls
echo.
pause
goto :MAIN_MENU

:F_ENV_ADD
cls
echo.
echo   === Add Environment Variable ===
echo   Follow the prompts to add a new variable.
echo.
call vercel env add
echo.
pause
goto :MAIN_MENU

:F_ENV_RM
cls
echo.
echo   === Remove Environment Variable ===
echo   Follow the prompts to remove a variable.
echo.
call vercel env rm
echo.
pause
goto :MAIN_MENU

:F_ENV_PULL
cls
echo.
echo   === Pull Env to .env File ===
echo   Downloads environment variables to a local .env file.
echo.
call vercel env pull
echo.
pause
goto :MAIN_MENU


REM ================================================================
REM   DOMAINS
REM ================================================================
:F_DOMAINS_LS
cls
echo.
echo   === List Domains ===
echo.
call vercel domains ls
echo.
pause
goto :MAIN_MENU

:F_DOMAINS_ADD
cls
echo.
echo   === Add Domain ===
echo   Type the domain name you want to add.
echo.

set "NEW_DOMAIN="
set /p "NEW_DOMAIN=   Domain name (or press Enter to skip): "
if "!NEW_DOMAIN!"=="" goto :MAIN_MENU

call vercel domains add !NEW_DOMAIN!
echo.
pause
goto :MAIN_MENU

:F_DOMAINS_RM
cls
echo.
echo   === Remove Domain ===
echo   Type the domain name you want to remove.
echo.

set "RM_DOMAIN="
set /p "RM_DOMAIN=   Domain name (or press Enter to skip): "
if "!RM_DOMAIN!"=="" goto :MAIN_MENU

call vercel domains rm !RM_DOMAIN!
echo.
pause
goto :MAIN_MENU


REM ================================================================
REM   ADVANCED
REM ================================================================
:F_PROMOTE
cls
echo.
echo   === Promote Deploy ===
echo   Move a preview deploy to production.
echo   Type the deploy URL.
echo.

set "PROMO_URL="
set /p "PROMO_URL=   Deploy URL (or press Enter to skip): "
if "!PROMO_URL!"=="" goto :MAIN_MENU

call vercel promote !PROMO_URL!
echo.
pause
goto :MAIN_MENU

:F_ROLLBACK
cls
echo.
echo   === Rollback Deploy ===
echo   Go back to an older deployment.
echo   Type the deploy URL to roll back to.
echo.

set "ROLL_URL="
set /p "ROLL_URL=   Deploy URL (or press Enter to skip): "
if "!ROLL_URL!"=="" goto :MAIN_MENU

call vercel rollback !ROLL_URL!
echo.
pause
goto :MAIN_MENU

:F_REMOVE
cls
echo.
echo   === Remove Deploy ===
echo   Delete a deployment.
echo   Type the deploy URL.
echo.

set "DEL_URL="
set /p "DEL_URL=   Deploy URL (or press Enter to skip): "
if "!DEL_URL!"=="" goto :MAIN_MENU

call vercel remove !DEL_URL!
echo.
pause
goto :MAIN_MENU

:F_PULL
cls
echo.
echo   === Pull Project Settings ===
echo   Downloads project settings and env from Vercel.
echo.
call vercel pull
echo.
pause
goto :MAIN_MENU

:F_INIT
cls
echo.
echo   === Init New Project ===
echo   Start a new project from a Vercel template.
echo.
call vercel init
echo.
pause
goto :MAIN_MENU

:F_ALIAS
cls
echo.
echo   === Alias (Custom URL) ===
echo   Give a custom URL to a deployment.
echo   Usage: vercel alias [deploy-url] [custom-domain]
echo.

set "ALIAS_SRC="
set /p "ALIAS_SRC=   Deploy URL: "
if "!ALIAS_SRC!"=="" goto :MAIN_MENU

set "ALIAS_DST="
set /p "ALIAS_DST=   Custom domain: "
if "!ALIAS_DST!"=="" goto :MAIN_MENU

call vercel alias !ALIAS_SRC! !ALIAS_DST!
echo.
pause
goto :MAIN_MENU

:F_DNS
cls
echo.
echo   === DNS Records ===
echo   Shows DNS records for a domain.
echo.

set "DNS_DOMAIN="
set /p "DNS_DOMAIN=   Domain name (or press Enter to skip): "
if "!DNS_DOMAIN!"=="" goto :MAIN_MENU

call vercel dns ls !DNS_DOMAIN!
echo.
pause
goto :MAIN_MENU


REM ================================================================
REM   TOOLS
REM ================================================================
:F_VERSION
cls
echo.
echo   === Version Check ===
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
echo   === Update Vercel CLI ===
echo   Updating to the newest version ...
echo.
call npm install -g vercel@latest
echo.

set "VERCEL_VER="
for /f "tokens=*" %%v in ('vercel --version 2^>nul') do set "VERCEL_VER=%%v"
echo   Updated to: !VERCEL_VER!
echo.
pause
goto :MAIN_MENU

:F_HELP
cls
echo.
echo   === Help ===
echo.
call vercel help
echo.
pause
goto :MAIN_MENU


REM ================================================================
REM   EXIT
REM ================================================================
:EXIT_APP
echo.
echo   Goodbye! Thank you for using Vercel CLI.
echo.
endlocal
exit /b 0


REM ================================================================
REM   ERROR HANDLER
REM ================================================================
:ERR_NOT_INSTALLED
echo.
echo ============================================================
echo   [ERROR] Vercel CLI is not installed!
echo ============================================================
echo.
echo   Please run INSTALL.bat first.
echo.
pause
endlocal
exit /b 1