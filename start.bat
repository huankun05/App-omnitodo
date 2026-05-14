@echo off
chcp 65001 >nul
echo ============================================
echo        OmniTodo Quick Start Script
echo ============================================
echo.

set ROOT_DIR=%~dp0
cd /d "%ROOT_DIR%"

REM Check if Supabase is configured
if exist "%ROOT_DIR%server\.env.supabase" (
    echo [Mode] Using Supabase Cloud Database
    copy /Y "%ROOT_DIR%server\.env.supabase" "%ROOT_DIR%server\.env" >nul
) else (
    echo [Mode] Using SQLite Local Database
)

echo.
echo [1/7] Checking for existing processes on port 3000...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :3000 ^| findstr LISTENING') do (
    echo     Found existing process on port 3000, terminating PID %%a...
    taskkill /PID %%a /F >nul 2>&1
)
echo     Port 3000 is now free

echo.
echo [2/7] Checking backend dependencies...
if not exist "%ROOT_DIR%server\node_modules" (
    echo     First run, installing dependencies...
    cd server
    call npm install --ignore-scripts
    call npx prisma generate
    call npx prisma db push
    cd ..
    echo.
)

echo [3/7] Starting database service...
if exist "%ROOT_DIR%server\.env.supabase" (
    echo     Using Supabase Cloud Database - no local database service needed
) else (
    echo     Initializing SQLite Local Database...
    cd server
    call npx prisma db push --accept-data-loss >nul 2>&1
    if %errorlevel% equ 0 (
        echo     SQLite Database initialized successfully
    ) else (
        echo     Warning: Failed to initialize SQLite Database
    )
    cd ..
)

echo.
echo [4/7] Syncing database schema...
cd server
call npx prisma db push --accept-data-loss >nul 2>&1
if %errorlevel% equ 0 (
    echo     Database schema synced successfully
) else (
    echo     Warning: Failed to sync database schema
)
cd ..

echo [5/7] Starting backend service...
start "OmniTodo-Backend" cmd /k "cd /d %ROOT_DIR%server && npm start"

echo.
echo [6/7] Opening database...
timeout /t 5 /nobreak >nul
if exist "%ROOT_DIR%server\.env.supabase" (
    echo     Opening Supabase Console...
    start "Supabase Console" "https://app.supabase.com"
) else (
    echo     Opening Prisma Studio...
    start "Prisma Studio" cmd /k "cd /d %ROOT_DIR%server && npx prisma studio"
)

echo.
echo [7/7] Starting Flutter frontend...
start "OmniTodo-Frontend" cmd /k "cd /d %ROOT_DIR% && flutter run -d chrome"

echo.
echo ============================================
echo        Startup Complete!
echo ============================================
echo.
echo Backend service: http://localhost:3000
echo Flutter frontend: Running in new window
if exist "%ROOT_DIR%server\.env.supabase" (
    echo Database: Supabase Cloud Database
) else (
    echo Database: SQLite (auto-created at server\prisma\dev.db)
)
echo.
echo ============================================
echo.
pause
