@echo off
setlocal

title EventSphere Launcher

REM EventSphere local development launcher
REM Place this file in the EventSphere root folder.

set "PROJECT_DIR=%~dp0"
set "BACKEND_DIR=%PROJECT_DIR%backend"
set "FRONTEND_DIR=%PROJECT_DIR%frontend"
set "ML_DIR=%PROJECT_DIR%python-ai"

echo.
echo ============================================================
echo                 EVENTSPHERE STARTUP
echo ============================================================
echo Project: %PROJECT_DIR%
echo.

if not exist "%BACKEND_DIR%\server.js" (
    echo [ERROR] backend\server.js was not found.
    echo Place start.bat in the EventSphere root folder.
    pause
    exit /b 1
)

if not exist "%FRONTEND_DIR%\package.json" (
    echo [ERROR] frontend\package.json was not found.
    pause
    exit /b 1
)

if not exist "%ML_DIR%\app.py" (
    echo [ERROR] python-ai\app.py was not found.
    pause
    exit /b 1
)

echo [1/3] Starting Node.js backend...
start "EventSphere Backend - Port 5000" cmd /k "cd /d ""%BACKEND_DIR%"" && node server.js"

timeout /t 2 /nobreak >nul

echo [2/3] Starting Python ML service...
if exist "%ML_DIR%\venv\Scripts\activate.bat" (
    start "EventSphere ML - Port 5001" cmd /k "cd /d ""%ML_DIR%"" && call venv\Scripts\activate.bat && python app.py"
) else (
    echo [WARNING] Python virtual environment not found. Using system Python.
    start "EventSphere ML - Port 5001" cmd /k "cd /d ""%ML_DIR%"" && python app.py"
)

timeout /t 2 /nobreak >nul

echo [3/3] Starting React frontend...
start "EventSphere Frontend - Port 5173" cmd /k "cd /d ""%FRONTEND_DIR%"" && npm run dev"

echo.
echo ============================================================
echo              STARTUP COMMANDS SENT
echo ============================================================
echo Frontend : http://localhost:5173
echo Backend  : http://localhost:5000
echo Backend health: http://localhost:5000/api/health
echo ML service: http://localhost:5001
echo ML health : http://localhost:5001/health
echo.
echo IMPORTANT:
echo 1. Start MySQL from XAMPP Control Panel first.
echo 2. Keep all three service terminal windows open.
echo 3. If dependencies are missing, install them in the relevant folder.
echo ============================================================
echo.
pause

endlocal
