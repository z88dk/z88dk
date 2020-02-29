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
 * Board (hardware) specific definitions for the Z80 boards that I use regularly.
 * This includes
 * YAZ180 with Z8S180
 * SCZ180 with Z8S180
 * RC2014 with Z80
 * Spectrum Next with Z80N
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

#define configTICK_RATE_HZ              ( ( TickType_t ) 256 )
#define configSWITCH_CONTEXT()          vTaskSwitchContext()

#ifdef __SCCZ80

#define configSETUP_TIMER_INTERRUPT()                           \
    do{                                                         \
        asm(                                                    \
            "EXTERN __CPU_CLOCK                             \n" \
            "EXTERN RLDR1L, RLDR1H                          \n" \
            "EXTERN TCR, TCR_TIE1, TCR_TDE1                 \n" \
            "ld de,_timer_isr                               \n" \
            "ld hl,0xFFE6       ; YAZ180 PRT1 address       \n" \
            "ld (hl),e                                      \n" \
            "inc hl                                         \n" \
            "ld (hl),d                                      \n" \
            "ld hl,__CPU_CLOCK/256/20-1                     \n" \
            "out0(RLDR1L),l                                 \n" \
            "out0(RLDR1H),h                                 \n" \
            "in0 a,(TCR)                                    \n" \
            "or TCR_TIE1|TCR_TDE1                           \n" \
            "out0 (TCR),a                                   \n" \
            );                                                  \
    }while(0)

#define configRESET_TIMER_INTERRUPT()                           \
    do{                                                         \
        asm(                                                    \
            "EXTERN TCR, TMDR1L                             \n" \
            "in0 a,(TCR)                                    \n" \
            "in0 a,(TMDR1L)                                 \n" \
            );                                                  \
    }while(0)

#define configSTOP_TIMER_INTERRUPT()                            \
    do{                                                         \
        asm(                                                    \
            "EXTERN TCR, TCR_TIE1, TCR_TDE1                 \n" \
            "; disable down counting and interrupts for PRT1\n" \
            "in0 a,(TCR)                                    \n" \
            "xor TCR_TIE1|TCR_TDE1                          \n" \
            "out0 (TCR),a                                   \n" \
            );                                                  \
    }while(0)

#endif

#ifdef __SDCC

#define configSETUP_TIMER_INTERRUPT()                           \
    do{                                                         \
        __asm                                                   \
            EXTERN __CPU_CLOCK                                  \
            EXTERN RLDR1L, RLDR1H                               \
            EXTERN TCR, TCR_TIE1, TCR_TDE1                      \
            ; address of ISR                                    \
            ld de,_timer_isr                                    \
            ld hl,0xFFE6        ; YAZ180 PRT1 address           \
            ld (hl),e                                           \
            inc hl                                              \
            ld (hl),d                                           \
            ; we do 256 ticks per second                        \
            ld hl,__CPU_CLOCK/256/20-1                          \
            out0(RLDR1L),l                                      \
            out0(RLDR1H),h                                      \
            ; enable down counting and interrupts for PRT1      \
            in0 a,(TCR)                                         \
            or TCR_TIE1|TCR_TDE1                                \
            out0 (TCR),a                                        \
        __endasm;                                               \
    }while(0)  

#define configRESET_TIMER_INTERRUPT()                           \
    do{                                                         \
        __asm                                                   \
            EXTERN TCR, TMDR1L                                  \
            ; reset interrupt for PRT1                          \
            in0 a,(TCR)                                         \
            in0 a,(TMDR1L)                                      \
        __endasm;                                               \
    }while(0)

#define configSTOP_TIMER_INTERRUPT()                            \
    do{                                                         \
        __asm                                                   \
            EXTERN TCR, TCR_TIE1, TCR_TDE1                      \
            ; disable down counting and interrupts for PRT1     \
            in0 a,(TCR)                                         \
            xor TCR_TIE1|TCR_TDE1                               \
            out0 (TCR),a                                        \
        __endasm;                                               \
    }while(0)

#endif
#endif

#ifdef __SCZ180

#define configTICK_RATE_HZ              ( ( TickType_t ) 256 )

#ifdef __SCCZ80

#define configSWITCH_CONTEXT()                                  \
    do{                                                         \
        asm(                                                    \
            "EXTERN BBR                                     \n" \
            "in0 a,(BBR)                                    \n" \
            "xor 0xF0           ; BBR for TPA               \n" \
            "call Z,vTaskSwitchContext                      \n" \
            );                                                  \
    }while(0)

#define configSETUP_TIMER_INTERRUPT()                       \
    do{                                                         \
        asm(                                                    \
            "EXTERN __CPU_CLOCK                             \n" \
            "EXTERN RLDR1L, RLDR1H                          \n" \
            "EXTERN TCR, TCR_TIE1, TCR_TDE1                 \n" \
            "ld hl,_timer_isr   ; move timer_isr() to a     \n" \
            "ld de,0xFB00       ; destination above 0x8000  \n" \
            "push de                                        \n" \
            "ld bc,0x0050       ; copy 0x50 Bytes           \n" \
            "ldir               ; copy timer_isr()          \n" \
            "pop de             ; destination to DE         \n" \
            "ld hl,0xFF06       ; SCZ180 PRT1 address       \n" \
            "ld (hl),e                                      \n" \
            "inc hl                                         \n" \
            "ld (hl),d                                      \n" \
            "ld hl,__CPU_CLOCK/256/20-1                     \n" \
            "out0(RLDR1L),l                                 \n" \
            "out0(RLDR1H),h                                 \n" \
            "in0 a,(TCR)                                    \n" \
            "or TCR_TIE1|TCR_TDE1                           \n" \
            "out0 (TCR),a                                   \n" \
            );                                                  \
    }while(0)

#define configRESET_TIMER_INTERRUPT()                           \
    do{                                                         \
        asm(                                                    \
            "EXTERN TCR, TMDR1L                             \n" \
            "in0 a,(TCR)                                    \n" \
            "in0 a,(TMDR1L)                                 \n" \
            );                                                  \
    }while(0)

#define configSTOP_TIMER_INTERRUPT()                            \
    do{                                                         \
        asm(                                                    \
            "EXTERN TCR, TCR_TIE1, TCR_TDE1                 \n" \
            "in0 a,(TCR)                                    \n" \
            "xor TCR_TIE1|TCR_TDE1                          \n" \
            "out0 (TCR),a                                   \n" \
            );                                                  \
    }while(0)

#endif

#ifdef __SDCC

#define configSWITCH_CONTEXT()                                  \
    do{                                                         \
        __asm                                                   \
            EXTERN BBR                                          \
            in0 a,(BBR)                                         \
            xor 0xF0            ; BBR for TPA                   \
            call Z,_vTaskSwitchContext                          \
        __endasm;                                               \
    }while(0)

#define configSETUP_TIMER_INTERRUPT()                           \
    do{                                                         \
        __asm                                                   \
            EXTERN __CPU_CLOCK                                  \
            EXTERN RLDR1L, RLDR1H                               \
            EXTERN TCR, TCR_TIE1, TCR_TDE1                      \
            ; address of ISR                                    \
            ld hl,_timer_isr    ; move timer_isr() to a         \
            ld de,0xFB00        ; destination above 0x8000      \
            push de                                             \
            ld bc,0x0050        ; copy 0x50 Bytes               \
            ldir                ; copy timer_isr()              \
            pop de              ; destination to DE             \
            ld hl,0xFF06        ; SCZ180 PRT1 address           \
            ld (hl),e                                           \
            inc hl                                              \
            ld (hl),d                                           \
            ; we do 256 ticks per second                        \
            ld hl,__CPU_CLOCK/256/20-1                          \
            out0(RLDR1L),l                                      \
            out0(RLDR1H),h                                      \
            ; enable down counting and interrupts for PRT1      \
            in0 a,(TCR)                                         \
            or TCR_TIE1|TCR_TDE1                                \
            out0 (TCR),a                                        \
        __endasm;                                               \
    }while(0)  

#define configRESET_TIMER_INTERRUPT()                           \
    do{                                                         \
        __asm                                                   \
            EXTERN TCR, TMDR1L                                  \
            ; reset interrupt for PRT1                          \
            in0 a,(TCR)                                         \
            in0 a,(TMDR1L)                                      \
        __endasm;                                               \
    }while(0)

#define configSTOP_TIMER_INTERRUPT()                            \
    do{                                                         \
        __asm                                                   \
            EXTERN TCR, TCR_TIE1, TCR_TDE1                      \
            ; disable down counting and interrupts for PRT1     \
            in0 a,(TCR)                                         \
            xor TCR_TIE1|TCR_TDE1                               \
            out0 (TCR),a                                        \
        __endasm;                                               \
    }while(0)

#endif
#endif

#ifdef __cplusplus
}
#endif

#endif // freeRTOSBoardDefs_h
