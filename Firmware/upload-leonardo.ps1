<#
.SYNOPSIS
    Compiles the Simple Button Box sketch and uploads it to an ATmega32U4 board
    (Arduino Pro Micro / Leonardo / Micro) on Windows, without having to time the reset button.

.DESCRIPTION
    1. Compiles the sketch with the arduino-cli that ships inside Arduino IDE 2 (or one on your PATH).
    2. Finds the board's COM port by its USB ID and asks it to reboot into its bootloader
       (the same "1200 baud touch" the Arduino IDE does).
    3. Waits for the bootloader port to appear (or for you to double-tap reset), then uploads with avrdude.

    See README.md in this folder for setup and usage.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\upload-leonardo.ps1

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\upload-leonardo.ps1 -Hex .\my_sketch.ino.hex
#>
param(
    # Sketch folder to compile (default: the sketch next to this script)
    [string]$Sketch = (Join-Path $PSScriptRoot "Simple_Button_box_sketch"),
    # Upload an already-compiled .hex instead of compiling
    [string]$Hex,
    # Board type for compiling. Use "SparkFun:avr:promicro:cpu=8MHzatmega32U4" for a 3.3V/8MHz Pro Micro.
    [string]$Fqbn = "arduino:avr:leonardo",
    # Board's normal COM port, if auto-detect can't find it (e.g. "COM5")
    [string]$Port,
    # How long to wait for the bootloader
    [int]$WaitSeconds = 30
)

$ErrorActionPreference = "Stop"

# USB IDs of 32U4 boards running a sketch, and of their bootloaders
$sketchIds = 'VID_2341&PID_8036', 'VID_2341&PID_8037', 'VID_2A03&PID_8036', 'VID_1B4F&PID_9206', 'VID_1B4F&PID_9204'
$bootIds   = 'VID_2341&PID_0036', 'VID_2341&PID_0037', 'VID_2A03&PID_0036', 'VID_1B4F&PID_9205', 'VID_1B4F&PID_9203'

function Find-ComPort([string[]]$ids) {
    $live = [System.IO.Ports.SerialPort]::GetPortNames()
    foreach ($dev in Get-CimInstance Win32_PnPEntity -Filter "Name LIKE '%(COM%'" -ErrorAction SilentlyContinue) {
        foreach ($id in $ids) {
            if ($dev.DeviceID -like "USB\$id*" -and $dev.Name -match '\((COM\d+)\)' -and $live -contains $Matches[1]) {
                return $Matches[1]
            }
        }
    }
    return $null
}

function Find-FirstFile([string[]]$candidates) {
    foreach ($c in $candidates) {
        $hit = Get-ChildItem $c -ErrorAction SilentlyContinue | Sort-Object FullName -Descending | Select-Object -First 1
        if ($hit) { return $hit.FullName }
    }
    return $null
}

# ---------- 1. Compile (unless a .hex was given) ----------
if (-not $Hex) {
    $cli = (Get-Command arduino-cli -ErrorAction SilentlyContinue).Source
    if (-not $cli) {
        $cli = Find-FirstFile @(
            "$env:ProgramFiles\Arduino IDE\resources\app\lib\backend\resources\arduino-cli.exe",
            "$env:LOCALAPPDATA\Programs\Arduino IDE\resources\app\lib\backend\resources\arduino-cli.exe")
    }
    if (-not $cli) {
        Write-Host "Couldn't find arduino-cli. Install Arduino IDE 2 (see README.md), or compile in the IDE and pass -Hex." -ForegroundColor Red
        exit 1
    }
    if (-not (Test-Path $Sketch)) { Write-Host "Sketch folder not found: $Sketch" -ForegroundColor Red; exit 1 }

    $buildDir = Join-Path $env:TEMP "SimpleButtonBox-build"
    Write-Host "Compiling $Sketch for $Fqbn ..." -ForegroundColor Cyan
    & $cli compile --fqbn $Fqbn --output-dir $buildDir $Sketch
    if ($LASTEXITCODE -ne 0) { Write-Host "Compile failed - see errors above (missing Joystick library?)." -ForegroundColor Red; exit 1 }
    $Hex = Get-ChildItem $buildDir -Filter *.ino.hex | Where-Object { $_.Name -notmatch 'bootloader' } | Select-Object -First 1 -ExpandProperty FullName
}
if (-not (Test-Path $Hex)) { Write-Host "Hex file not found: $Hex" -ForegroundColor Red; exit 1 }
$Hex = (Resolve-Path $Hex).Path

# ---------- 2. Find avrdude ----------
$avrdude = Find-FirstFile @(
    "$env:LOCALAPPDATA\Arduino15\packages\arduino\tools\avrdude\*\bin\avrdude.exe",
    "${env:ProgramFiles(x86)}\Arduino\hardware\tools\avr\bin\avrdude.exe",
    "$env:ProgramFiles\Arduino\hardware\tools\avr\bin\avrdude.exe")
if (-not $avrdude) {
    Write-Host "Couldn't find avrdude. In Arduino IDE, install 'Arduino AVR Boards' from the Boards Manager." -ForegroundColor Red
    exit 1
}
$conf = Join-Path (Split-Path (Split-Path $avrdude)) "etc\avrdude.conf"

# ---------- 3. Reboot the board into its bootloader ----------
Write-Host "Uploading: $Hex"
if (-not $Port) { $Port = Find-ComPort $sketchIds }
$bootPort = Find-ComPort $bootIds

if (-not $bootPort) {
    if ($Port) {
        try {
            $sp = New-Object System.IO.Ports.SerialPort $Port, 1200
            $sp.Open(); $sp.DtrEnable = $false; Start-Sleep -Milliseconds 100; $sp.Close()
            Write-Host "Asked the board on $Port to enter upload mode."
        } catch {
            Write-Host "Couldn't open $Port ($($_.Exception.Message)). Close Serial Monitor/other apps, or double-tap reset." -ForegroundColor Yellow
        }
    } else {
        Write-Host "Board not detected automatically." -ForegroundColor Yellow
    }
    Write-Host ">>> If the board's LED isn't slowly fading, DOUBLE-TAP RESET (or touch RST to GND twice) NOW." -ForegroundColor Cyan
    Write-Host "    Waiting up to $WaitSeconds s for upload mode..."

    $deadline = (Get-Date).AddSeconds($WaitSeconds)
    while ((Get-Date) -lt $deadline -and -not $bootPort) {
        $bootPort = Find-ComPort $bootIds
        if (-not $bootPort) { Start-Sleep -Milliseconds 50 }
    }
}
if (-not $bootPort) { Write-Host "Upload mode never appeared. Run the script again and double-tap reset." -ForegroundColor Red; exit 1 }

# ---------- 4. Upload ----------
Write-Host "Found upload port $bootPort - uploading. DON'T TOUCH THE BOARD." -ForegroundColor Green
for ($try = 1; $try -le 6; $try++) {
    Start-Sleep -Milliseconds 500
    & $avrdude "-C$conf" -v -patmega32u4 -cavr109 "-P$bootPort" -b57600 -D "-Uflash:w:${Hex}:i"
    if ($LASTEXITCODE -eq 0) { break }
    Write-Host "Attempt $try failed - retrying..." -ForegroundColor Yellow
}
if ($LASTEXITCODE -eq 0) { Write-Host "`nUPLOAD OK!" -ForegroundColor Green; exit 0 }
Write-Host "`nUpload failed (exit $LASTEXITCODE)." -ForegroundColor Red
exit 1
