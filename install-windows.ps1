# Nyx-AI-Translator Windows dependency helper
# Run in PowerShell from this folder:
#   powershell -ExecutionPolicy Bypass -File .\install-windows.ps1

$ErrorActionPreference = "Continue"

Write-Host "Nyx-AI-Translator Windows setup"
Write-Host "Installing/checking Python, FFmpeg, and MKVToolNix via winget when available..."

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Host "winget not found. Install manually:"
  Write-Host "Python: https://www.python.org/downloads/windows/"
  Write-Host "FFmpeg: https://www.gyan.dev/ffmpeg/builds/"
  Write-Host "MKVToolNix: https://mkvtoolnix.download/"
  exit 1
}

if (-not (Get-Command py -ErrorAction SilentlyContinue) -and -not (Get-Command python -ErrorAction SilentlyContinue)) {
  winget install --id Python.Python.3.11 -e
}

if (-not (Get-Command ffprobe -ErrorAction SilentlyContinue) -or -not (Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
  winget install --id Gyan.FFmpeg -e
}

if (-not (Get-Command mkvextract -ErrorAction SilentlyContinue)) {
  winget install --id MoritzBunkus.MKVToolNix -e
}

$pythonCmd = $null
if (Get-Command py -ErrorAction SilentlyContinue) { $pythonCmd = "py -3" }
elseif (Get-Command python -ErrorAction SilentlyContinue) { $pythonCmd = "python" }

if ($pythonCmd) {
  Invoke-Expression "$pythonCmd -m pip install -r requirements.txt"
  Invoke-Expression "$pythonCmd Nyx-AI-Translator.py --check"
} else {
  Write-Host "Python still not found. Reopen PowerShell, or reinstall Python with PATH enabled."
  exit 1
}
