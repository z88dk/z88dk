/*
 * Copyright (C) 2020 Phillip Stevens  All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * 1 tab == 4 spaces!
 *
 * This file is NOT part of the FreeRTOS distribution.
 *
 */

include(__link__.m4)

/* freeRTOSBoardDefs.h
 *
 * Board (hardware) specific definitions for the AVR boards that I use regularly.
 * This includes
 * Arduino UNO with ATmega328p
 * Goldilocks with ATmega1284p
 * Arduino MEGA with ATmega2560
 *
 * And also Pololu SVP with ATmega1284p
 *
 * This file is NOT part of the FreeRTOS distribution.
 *
 */

#ifndef freeRTOSBoardDefs_h
#define freeRTOSBoardDefs_h

#ifdef __cplusplus
extern "C" {
#endif

// System Tick - Scheduler timer
// Use the Watchdog timer, and choose the rate at which scheduler interrupts will occur.

#define portUSE_WDTO            WDTO_15MS    // portUSE_WDTO to use the Watchdog Timer for xTaskIncrementTick

/* Watchdog period options:     WDTO_15MS
                                WDTO_30MS
                                WDTO_60MS
                                WDTO_120MS
                                WDTO_250MS
                                WDTO_500MS
*/
//    xxx Watchdog Timer is 128kHz nominal, but 120 kHz at 5V DC and 25 degrees is actually more accurate, from data sheet.
#define configTICK_RATE_HZ  ( (TickType_t)( (uint32_t)128000 >> (portUSE_WDTO + 11) ) )  // 2^11 = 2048 WDT scaler for 128kHz Timer

#ifdef __cplusplus
}
#endif

#endif // freeRTOSBoardDefs_h
