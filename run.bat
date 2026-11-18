@echo off
cd /d "%~dp0"

rem --- Find a Python interpreter (py launcher first, then python on PATH) ---
set "PY="
where py >nul 2>nul && set "PY=py -3"
if not defined PY (
    where python >nul 2>nul && set "PY=python"
)
if not defined PY (
    echo Python was not found. Install it from python.org and tick "Add python.exe to PATH".
    pause
    exit /b 1
)

rem --- Create an isolated environment once; reuse it on later runs ---
if not exist ".venv\Scripts\python.exe" (
    echo Creating virtual environment...
    %PY% -m venv .venv
    if errorlevel 1 (
        echo Could not create the virtual environment.
        pause
        exit /b 1
    )
)
set "VPY=.venv\Scripts\python.exe"

echo Installing dependencies...
"%VPY%" -m pip install --upgrade pip
"%VPY%" -m pip install --prefer-binary -r requirements.txt
if errorlevel 1 (
    echo.
    echo Dependency install failed. See the error above.
    echo If it keeps failing, delete the .venv folder and run this again.
    pause
    exit /b 1
)

echo.
echo Starting window manager...
"%VPY%" windowmanager.py


