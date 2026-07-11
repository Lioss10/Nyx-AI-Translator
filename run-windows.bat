@echo off
setlocal
cd /d "%~dp0"

where py >nul 2>nul
if %ERRORLEVEL%==0 (
  py -3 Nyx-AI-Translator.py %*
  exit /b %ERRORLEVEL%
)

where python >nul 2>nul
if %ERRORLEVEL%==0 (
  python Nyx-AI-Translator.py %*
  exit /b %ERRORLEVEL%
)

echo Python 3.10+ was not found.
echo.
echo Install it with one of these:
echo   winget install Python.Python.3.11
echo   https://www.python.org/downloads/windows/
echo.
echo IMPORTANT: tick "Add python.exe to PATH" in the installer, then reopen PowerShell.
echo If Windows opens Microsoft Store, disable App execution aliases for python.exe/python3.exe.
exit /b 1
