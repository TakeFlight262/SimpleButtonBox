# Firmware

The code for the Simple Button Box. It runs on an **Arduino Pro Micro** (ATmega32U4). It also works on a Leonardo or Micro. Windows sees the box as a normal **game controller**, so once it's flashed, no drivers or software are needed.

```
Firmware/
├── Simple_Button_box_sketch/
│   └── Simple_Button_box_sketch.ino   ← the code
└── upload-leonardo.ps1                ← optional upload helper (Windows)
```

## Pinout

| Function | Pins | Windows button # |
|---|---|---|
| Matrix rows | 2, 3, 4 | |
| Matrix columns | 5, 6, 7 | buttons 1–9 |
| Toggle 1 (up / down) | 9 / 10 | 10 / 11 |
| Toggle 2 (up / down) | 14 / 15 | 12 / 13 |

The toggles' common wire goes to **GND**. If you wire things differently, change the pin numbers at the top of the sketch.

## 1. One-time setup

1. Install **[Arduino IDE 2](https://www.arduino.cc/en/software)**.
2. **Tools → Board → Boards Manager**, and install **Arduino AVR Boards**. It may already be installed.
3. Install the **Joystick** library by Matthew Heironimus. It isn't in the Library Manager:
   1. Download the ZIP from <https://github.com/MHeironimus/ArduinoJoystickLibrary> (**Code → Download ZIP**).
   2. In the IDE, choose **Sketch → Include Library → Add .ZIP Library…** and pick the downloaded ZIP.
   - If the IDE complains, unzip it and copy the inner **`Joystick`** folder into `Documents\Arduino\libraries\`.

## 2. Upload: Option A, Arduino IDE (any OS)

1. Open `Simple_Button_box_sketch/Simple_Button_box_sketch.ino`.
2. **Tools → Board → Arduino AVR Boards → Arduino Leonardo** (a 5V/16MHz Pro Micro uses this).
   - **3.3V / 8MHz Pro Micro:** don't pick Leonardo. Install SparkFun's board package and pick that board instead, or the upload will look like it bricked the board. A double-tap reset fixes that.
3. **Tools → Port**: pick the board's COM port.
4. Click **Upload**.

**If you get `butterfly_recv(...) failed` or the upload times out:** click Upload, and when the status bar says **"Uploading…"**, quickly **double-tap the reset button**. On a Pro Micro without a reset button, touch **RST to GND twice**. The LED slowly fades while the board is in upload mode, which only lasts about 8 seconds. If timing that is a pain, use Option B.

## 2. Upload: Option B, the helper script (Windows only)

`upload-leonardo.ps1` compiles the sketch, finds the board, puts it into upload mode, and uploads, so you don't have to time the reset. It needs the one-time setup above. It uses the tools that come with Arduino IDE 2.

Open PowerShell in this `Firmware` folder and run:

```powershell
powershell -ExecutionPolicy Bypass -File .\upload-leonardo.ps1
```

If it says *"double-tap reset now"*, do that once, then leave the board alone until it says **UPLOAD OK!**

`-ExecutionPolicy Bypass` lets this one script run without changing your PC's settings.

**Options:**

| Option | Use it when |
|---|---|
| `-Fqbn "SparkFun:avr:promicro:cpu=8MHzatmega32U4"` | You have a **3.3V/8MHz** Pro Micro. This needs SparkFun's board package. |
| `-Hex path\to\file.ino.hex` | You already compiled it, for example with **Sketch → Export Compiled Binary**, and just want to upload. |
| `-Sketch path\to\sketch_folder` | You want to upload a different sketch. |
| `-Port COM5` | The board isn't found automatically. |

## Testing

Press **Win + R**, type `joy.cpl`, and press Enter. Select the Arduino and click **Properties**. Each button should light up while pressed, and each toggle position should light its own button.

## Troubleshooting

- **The board isn't detected or the upload fails:** close the Serial Monitor, Cura, SimHub, and anything else that might hold the COM port. Try another USB cable, since some only carry power. Plug straight into the PC, not a hub.
- **One button never works or is flaky, but the rest are fine:** bridge the switch's two legs with a wire while watching `joy.cpl`. If it registers, the switch is bad. If not, check that button's solder joints and diode.
- **A whole row or column is dead:** check that wire's pin and solder joint, and check that the diodes face the right way. See the main README.
- **The box randomly disconnects:** make sure you're on the current sketch. It only sends updates every 2 ms. Older versions flooded USB with updates. Also try another cable or port.
