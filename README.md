# LED Sequential – VHDL Lab Project

> **Designers:** Luis Mercado & Rachnicha Rojjhanarittikorn  
> **Board:** Nexys A7 (Artix-7) – 100 MHz clock

---

## Overview

A single lit LED moves left or right across a 16-LED bar graph in response to button presses. The current LED position is shown simultaneously in **hexadecimal** and **decimal** on a four-digit seven-segment display. A dedicated reset button returns the system to its starting position (LED 0).

---

## System Architecture

```
leftButton  ──┐
               ├──► SIGNAL_SYNC ──► LEFT_PRESS_DETECT  ──► POSITION_DETECTOR ──► LED_MUX ──► leds[15:0]
rightButton ──┘                    RIGHT_PRESS_DETECT ──►         │
                                                                   └──► BINARY_TO_DECIMAL ──► SevenSegmentDriver ──► sevenSegs / anodes


```
<img width="1182" height="526" alt="AdobeExpressPhotos_4462a38f6041428c91681f5c75fdd1bb_CopyEdited" src="https://github.com/user-attachments/assets/3b1fe9f6-8e2f-443e-962a-56fc7b918b73" />


| Component | Description |
|---|---|
| `SIGNAL_SYNC` | Two-stage flip-flop synchronizer – eliminates metastability on async button inputs |
| `LEFT_PRESS_DETECT` | Rising-edge detector – converts left button press into a single-cycle `leftEn` pulse |
| `RIGHT_PRESS_DETECT` | Rising-edge detector – converts right button press into a single-cycle `rightEn` pulse |
| `POSITION_DETECTOR` | 4-bit up/down counter (0–15) – tracks current LED position |
| `LED_MUX` | One-hot encoder – lights exactly one of the 16 LEDs |
| `BINARY_TO_DECIMAL` | BCD converter – splits position (0–15) into tens and ones digits |
| `SevenSegmentDriver` | 1 kHz multiplexed driver for the 4-digit seven-segment display |

---

## File Structure

```
led-sequential/
├── README.md
├── src/
│   ├── LedSequential.vhd          # Top-level entity
│   ├── SIGNAL_SYNC.vhd            # Button synchronizer
│   ├── LEFT_PRESS_DETECT.vhd      # Left edge detector
│   ├── RIGHT_PRESS_DETECT.vhd     # Right edge detector
│   ├── POSITION_DETECTOR.vhd      # LED position counter
│   ├── LED_MUX.vhd                # One-hot LED encoder
│   ├── BINARY_TO_DECIMAL.vhd      # BCD converter
│   └── SevenSegmentDriver.vhd     # 7-segment display driver
└── sim/
    └── LedSequential_TB.vhd       # Testbench
```

---

## I/O Port Map

| Port | Direction | Width | Description |
|---|---|---|---|
| `leftButton` | in | 1-bit | Move LED left |
| `rightButton` | in | 1-bit | Move LED right |
| `reset` | in | 1-bit | Active-high reset (returns to position 0) |
| `clock` | in | 1-bit | 100 MHz system clock |
| `leds` | out | 16-bit | One-hot LED output |
| `sevenSegs` | out | 7-bit | Seven-segment segments (MSB = g, LSB = a) |
| `anodes` | out | 4-bit | Active-low anode selects (MSB = leftmost digit) |

---

## Behavior

- **Left button press** → LED moves one position to the left (position increments). Clamped at 15.
- **Right button press** → LED moves one position to the right (position decrements). Clamped at 0.
- **Both buttons pressed simultaneously** → no movement.
- **Reset** → LED returns to position 0; display shows `00`.
- **Seven-segment display** → rightmost two digits show the decimal position; leftmost two digits are blanked.

---

## Testbench Summary (`LedSequential_TB.vhd`)

| Test Case | Stimulus |
|---|---|
| 1 | Single left button press |
| 2 | Two consecutive right button presses |
| 3 | Five consecutive left button presses |
| 4 | Both buttons pressed simultaneously |
| 5 | Left button held down (debounce/hold test) |
| 6 | Reset asserted mid-operation |

Clock period: **10 ns** (100 MHz)

---

## How to Simulate (Vivado)

1. Create a new Vivado project targeting the Nexys A7 board.
2. Add all files in `src/` as design sources.
3. Add `sim/LedSequential_TB.vhd` as a simulation source.
4. Set `LedSequential_TB` as the top module for simulation.
5. Run **Behavioral Simulation** and inspect the waveform.

---

## Design Notes

- **Metastability mitigation:** `SIGNAL_SYNC` passes each button through two flip-flops before use, giving the signal time to resolve within a single clock cycle.
- **Debounce / hold prevention:** `LEFT_PRESS_DETECT` and `RIGHT_PRESS_DETECT` output a pulse only on the rising edge of the synchronized signal, so holding a button down does not continuously move the LED.
- **Display multiplexing:** `SevenSegmentDriver` cycles through the four digits at 1 kHz (scan rate), which appears as continuous illumination to the eye. Digits 2 and 3 (left side) are blanked since positions only range from 0–15.
