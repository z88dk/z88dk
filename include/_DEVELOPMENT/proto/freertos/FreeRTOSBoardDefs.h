/*
 * Copyright (C) 2023 Phillip Stevens  All Rights Reserved.
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
 *
 * This file is NOT part of the FreeRTOS distribution.
 *
 */

include(__link__.m4)

/* freeRTOSBoardDefs.h
 *
 * Board (hardware) specific definitions for the Z180 boards that I use regularly.
 * This includes
 * YAZ180 with Z8S180
 * SCZ180 with Z8S180
 *
 * This file is NOT part of the FreeRTOS distribution.
 *
 */

#ifndef freeRTOSBoardDefs_h
#define freeRTOSBoardDefs_h

#ifdef __cplusplus
    extern "C" {
#endif

#ifdef __YAZ180

#define configTICK_RATE_HZ              (256)
#define configISR_ORG                   ASMPC
#define configISR_IVT                   0xFFE6

#define configINCREMENT_TICK()          xTaskIncrementTick()
#define configSWITCH_CONTEXT()          vTaskSwitchContext()

#define configSETUP_TIMER_INTERRUPT()                           \
    do{                                                         \
        __asm__(                                                \
            "EXTERN __CPU_CLOCK                             \n" \
            "EXTERN RLDR1L, RLDR1H                          \n" \
            "EXTERN TCR, TCR_TIE1, TCR_TDE1                 \n" \
            "ld de,_timer_isr                               \n" \
            "ld hl,"string(configISR_IVT)" ; YAZ180 PRT1 address\n" \
            "ld (hl),e                                      \n" \
            "inc hl                                         \n" \
            "ld (hl),d                                      \n" \
            "; we do configTICK_RATE_HZ ticks per second    \n" \
            "ld hl,__CPU_CLOCK/"string(configTICK_RATE_HZ)"/20-1 \n" \
            "out0(RLDR1L),l                                 \n" \
            "out0(RLDR1H),h                                 \n" \
            "in0 a,(TCR)                                    \n" \
            "or TCR_TIE1|TCR_TDE1                           \n" \
            "out0 (TCR),a                                   \n" \
            );                                                  \
    }while(0)

#define configRESET_TIMER_INTERRUPT()                           \
    do{                                                         \
        __asm__(                                                \
            "EXTERN TCR, TMDR1L                             \n" \
            "in0 a,(TCR)                                    \n" \
            "in0 a,(TMDR1L)                                 \n" \
            );                                                  \
    }while(0)

#define configSTOP_TIMER_INTERRUPT()                            \
    do{                                                         \
        __asm__(                                                \
            "EXTERN TCR, TCR_TIE1, TCR_TDE1                 \n" \
            "; disable down counting and interrupts for PRT1\n" \
            "in0 a,(TCR)                                    \n" \
            "xor TCR_TIE1|TCR_TDE1                          \n" \
            "out0 (TCR),a                                   \n" \
            );                                                  \
    }while(0)

#endif

#ifdef __SCZ180

#define configTICK_RATE_HZ              (256)
#define configISR_ORG                   0xFB00
#define configISR_IVT                   0xFF06

#ifdef __SCCZ80

#define configINCREMENT_TICK()                                  \
    do{                                                         \
        __asm__(                                                \
            "EXTERN BBR                                     \n" \
            "in0 a,(BBR)                                    \n" \
            "xor 0xF0            ; BBR for user TPA         \n" \
            "jr NZ,ASMPC+9                                  \n" \
            "ld hl,0x0100                                   \n" \
            "add hl,sp           ; Check SP < 0xFFnn        \n" \
            "call NC,xTaskIncrementTick                     \n" \
            );                                                  \
    }while(0)

#define configSWITCH_CONTEXT()                                  \
    do{                                                         \
        __asm__(                                                \
            "EXTERN BBR                                     \n" \
            "in0 a,(BBR)                                    \n" \
            "xor 0xF0            ; BBR for user TPA         \n" \
            "jr NZ,ASMPC+9                                  \n" \
            "ld hl,0x0100                                   \n" \
            "add hl,sp           ; Check SP < 0xFFnn        \n" \
            "call NC,vTaskSwitchContext                     \n" \
            );                                                  \
    }while(0)

#endif

#ifdef __SDCC

#define configINCREMENT_TICK()                                  \
    do{                                                         \
        __asm__(                                                \
            "EXTERN BBR                                     \n" \
            "in0 a,(BBR)                                    \n" \
            "xor 0xF0                ; BBR for user TPA     \n" \
            "jr NZ,ASMPC+9                                  \n" \
            "ld hl,0x0100                                   \n" \
            "add hl,sp               ; Check SP < 0xFFnn    \n" \
            "call NC,_xTaskIncrementTick                    \n" \
            );                                                  \
    }while(0)

#define configSWITCH_CONTEXT()                                  \
    do{                                                         \
        __asm__(                                                \
            "EXTERN BBR                                     \n" \
            "in0 a,(BBR)                                    \n" \
            "xor 0xF0                ; BBR for user TPA     \n" \
            "jr NZ,ASMPC+9                                  \n" \
            "ld hl,0x0100                                   \n" \
            "add hl,sp               ; Check SP < 0xFFnn    \n" \
            "call NC,_vTaskSwitchContext                    \n" \
            );                                                  \
    }while(0)

#endif

#define configSETUP_TIMER_INTERRUPT()                           \
    do{                                                         \
        __asm__(                                                \
            "EXTERN __CPU_CLOCK                             \n" \
            "EXTERN RLDR1L, RLDR1H                          \n" \
            "EXTERN TCR, TCR_TIE1, TCR_TDE1                 \n" \
            "ld hl,_timer_isr       ; move timer_isr() to a \n" \
            "ld de,_timer_isr_start ; destination above 0x8000  \n" \
            "push de                                        \n" \
            "ld bc,_timer_isr_end-_timer_isr_start          \n" \
            "ldir                   ; copy timer_isr()      \n" \
            "pop de                 ; destination to DE     \n" \
            "ld hl,"string(configISR_IVT)" ; SCZ180 PRT1 address\n" \
            "ld (hl),e                                      \n" \
            "inc hl                                         \n" \
            "ld (hl),d                                      \n" \
            "; we do configTICK_RATE_HZ ticks per second    \n" \
            "ld hl,__CPU_CLOCK/"string(configTICK_RATE_HZ)"/20-1\n" \
            "out0 (RLDR1L),l                                \n" \
            "out0 (RLDR1H),h                                \n" \
            "in0 a,(TCR)                                    \n" \
            "or TCR_TIE1|TCR_TDE1                           \n" \
            "out0 (TCR),a                                   \n" \
            );                                                  \
    }while(0)

#define configRESET_TIMER_INTERRUPT()                           \
    do{                                                         \
        __asm__(                                                \
            "EXTERN TCR, TMDR1L                             \n" \
            "in0 a,(TCR)                                    \n" \
            "in0 a,(TMDR1L)                                 \n" \
            );                                                  \
    }while(0)

#define configSTOP_TIMER_INTERRUPT()                            \
    do{                                                         \
        __asm__(                                                \
            "EXTERN TCR, TCR_TIE1, TCR_TDE1                 \n" \
            "in0 a,(TCR)                                    \n" \
            "xor TCR_TIE1|TCR_TDE1                          \n" \
            "out0 (TCR),a                                   \n" \
            );                                                  \
    }while(0)

#endif

#ifdef __cplusplus
    }
#endif

#endif // freeRTOSBoardDefs_h
