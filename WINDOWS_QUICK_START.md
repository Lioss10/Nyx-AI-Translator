# Windows Quick Start

If `python Nyx-AI-Translator.py` says Python was not found, your Windows machine does not have Python on PATH or Microsoft Store aliases are intercepting it.

## Fast setup

Open PowerShell in this folder and run:

```powershell
powershell -ExecutionPolicy Bypass -File .\install-windows.ps1
```

Then close and reopen PowerShell.

## Run the tool

Prefer the launcher:

```powershell
.\run-windows.bat --check
.\run-windows.bat
```

The launcher tries `py -3` first, then `python`, and prints clear install instructions if neither exists.

## Manual install

```powershell
winget install Python.Python.3.11
winget install Gyan.FFmpeg
winget install MoritzBunkus.MKVToolNix
```

Then reopen PowerShell and run:

```powershell
py -3 -m pip install -r requirements.txt
py -3 Nyx-AI-Translator.py --check
py -3 Nyx-AI-Translator.py
```

## Microsoft Store Python problem

If you see:

```text
Python was not found; run without arguments to install from the Microsoft Store...
```

Fix:

1. Windows Settings
2. Apps
3. Advanced app settings
4. App execution aliases
5. Turn OFF:
   - `python.exe`
   - `python3.exe`
6. Install Python from python.org or winget.
7. Reopen PowerShell.

## Embedded subtitle requirement

Embedded video mode requires:

```powershell
ffprobe -version
ffmpeg -version
```

If `ffprobe not found`, install FFmpeg and reopen PowerShell.
