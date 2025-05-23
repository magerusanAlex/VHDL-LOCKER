# Cabinet Security System - Digital Lock

## Overview

This project implements a digital lock system for securing cabinets using an FPGA. Users can set and enter a 3-digit hexadecimal code to lock/unlock the cabinet.

## Features

- **3-digit hex code** (0-9, A-F)
- **Visual feedback** via:
  - 7-segment display
  - Status LEDs
- **Two operation modes**:
  - Set password (when unlocked)
  - Unlock (when locked)
- **Reset functionality**

## Hardware Requirements

- Nexys A7 FPGA board
- 7-segment display
- 2 LEDs
- 4 push buttons:
  - UP
  - DOWN
  - ADD_DIGIT
  - RESET
- 1 mode switch

## Pin Connections

See `Nexys_A7_Constraints.xdc` for complete pin mapping.

## Usage Instructions

### Setting a New Password

1. Ensure cabinet is unlocked
2. Set mode switch to SET position
3. Press ADD_DIGIT to begin
   - LED on
   - First digit shows on display
4. Use UP/DOWN to select digit (0-F)
5. Press ADD_DIGIT to confirm
6. Repeat for all 3 digits
7. After 3rd digit:
   - Display off
   - LED off
   - RED LED on (locked)

### Unlocking

1. Cabinet must be locked
2. Set mode switch to UNLOCK
3. Press ADD_DIGIT to begin
4. Enter 3-digit code same way
5. After 3rd digit:
   - Correct code: LED off (unlocked)
   - Wrong code: LED stays on

### Reset

Press RESET anytime to:

- Cancel operation
- Clear entered digits
- Return to idle state
- Turn off all indicators

## Code Structure

## Technical Specs

| Parameter     | Value        |
| ------------- | ------------ |
| Clock         | 100MHz       |
| Code length   | 3 digits     |
| Digit range   | 0-F (hex)    |
| Password bits | 12 (3×4-bit) |

## Testing

Verified functionality:

- [x] Password setting
- [x] Correct/incorrect unlocks
- [x] Reset function
- [x] Digit wrapping (0↔F)
- [x] Full hex range support
