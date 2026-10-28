# 🏠 Smart Home Voice Activation System
### Wokwi Arduino Simulation

A simulated smart home system built on Arduino that allows voice-activated control of home devices. When a device is turned on or off, the OLED display updates in real time to show the current status of all devices.

---

## 📋 Components

| Component | Model | Quantity |
|---|---|---|
| Microcontroller | Arduino Uno | 1 |
| Display | SSD1306 OLED 128x64 (I2C) | 1 |
| LEDs | Yellow, Red, Blue, Green | 4 |
| Resistors | 220Ω | 4 |
| Push Buttons | Any colour | 5 |

---

## 🔌 Pin Mapping

### Device Output Pins
| Device | Pin | LED Colour |
|---|---|---|
| Light | D2 | Yellow |
| Heater | D3 | Red |
| AC | D4 | Blue |
| Fan | D5 | Green |

### Button Input Pins
| Button | Pin | Action |
|---|---|---|
| Light Toggle | D6 | Turns Light ON/OFF |
| Heater Toggle | D7 | Turns Heater ON/OFF |
| AC Toggle | D8 | Turns AC ON/OFF |
| Fan Toggle | D9 | Turns Fan ON/OFF |
| All Off | D10 | Turns ALL devices OFF |

### OLED Display (I2C)
| Signal | Pin |
|---|---|
| SDA | A4 |
| SCL | A5 |
| VCC | 5V |
| GND | GND |

---

## 📦 Libraries Required

Install these libraries in Wokwi's Library Manager or via Arduino IDE:

- **Adafruit SSD1306** — OLED display driver
- **Adafruit GFX** — Graphics core library

---

## 🚀 How to Run

1. Go to [wokwi.com](https://wokwi.com) and create a new **Arduino Uno** project
2. Replace the default `diagram.json` with the provided `diagram.json`
3. Replace the default `sketch.ino` with the provided `sketch.ino`
4. Add the required libraries via the **Library Manager** (click the `+` icon)
5. Click the **▶ Play** button to start the simulation

---

## 🎙️ Voice Commands

Voice is simulated through the **Serial Monitor** (set baud rate to `9600`). Type any of the following commands and press **Enter**:

| Command | Action |
|---|---|
| `turn on light` | Turns the light ON |
| `turn off light` | Turns the light OFF |
| `turn on heater` | Turns the heater ON |
| `turn off heater` | Turns the heater OFF |
| `turn on ac` | Turns the AC ON |
| `turn off ac` | Turns the AC OFF |
| `turn on fan` | Turns the fan ON |
| `turn off fan` | Turns the fan OFF |
| `all off` | Turns ALL devices OFF |
| `everything off` | Turns ALL devices OFF |

> **Tip:** Commands are case-insensitive. `Turn On Light` and `turn on light` both work.

---

## 🔘 Push Button Controls

As an alternative to voice commands, the push buttons on the diagram simulate physical voice triggers:

| Button Colour | Device | Behaviour |
|---|---|---|
| Yellow | Light | Toggles ON ↔ OFF |
| Red | Heater | Toggles ON ↔ OFF |
| Blue | AC | Toggles ON ↔ OFF |
| Green | Fan | Toggles ON ↔ OFF |
| Black | ALL | Turns everything OFF |

---

## 📺 OLED Display Layout

```
┌──────────────────────────┐
│    SMART HOME STATUS     │  ← Header bar
├──────────────────────────┤
│ ● LIGHT       [ ON ]     │  ← Filled circle = ON
│ ○ HEATER      [ OFF]     │  ← Outline circle = OFF
│ ○ AC          [ OFF]     │
│ ● FAN         [ ON ]     │
├──────────────────────────┤
│ 2 devices active         │  ← Live summary
└──────────────────────────┘
```

- **Filled circle (●)** — device is ON
- **Outline circle (○)** — device is OFF
- Bottom bar shows total number of active devices or "All devices are OFF"

---

## 🗂️ File Structure

```
project/
├── diagram.json   # Wokwi circuit diagram (components + wiring)
├── sketch.ino     # Arduino source code
└── README.md      # This file
```

---

## 🛠️ How It Works

1. On startup, a welcome screen is shown on the OLED for 2 seconds
2. The system listens continuously for two types of input:
   - **Serial Monitor** text (voice simulation)
   - **Push button** presses on the circuit
3. When a command is received, the corresponding device (LED) is toggled ON or OFF
4. The OLED instantly updates to reflect the new state of all devices
5. If an unrecognized command is entered, an error message is briefly shown on the OLED

---

*Built for Wokwi simulation — easily adaptable for real hardware with a voice recognition module (e.g. DFRobot SEN0539 or elechouse Voice Recognition Module V3).*
