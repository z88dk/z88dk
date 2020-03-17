;
;  feilipu, 2020 January
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------
;
; Using RC2014 LUT Module
;
;------------------------------------------------------------------------------

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_math

PUBLIC l_lut_mulu_40_32x8

l_lut_mulu_40_32x8:

    ; multiplication of 32-bit number and 8-bit number into a 40-bit product
    ;
    ; enter :    a  = 8-bit multiplier     = x
    ;         dehl  = 32-bit multiplicand  = y
    ;            
    ; exit  : adehl = 40-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    ld b,a                      ; 4  operand X in B

    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    out (c),l                   ; 12 operand Y0 from L
    in l,(c)                    ; 12 result LSB to A
    inc c                       ; 4  result MSB address
    in a,(c)                    ; 12 result MSB to A

    dec c                       ; 4  operand latch address
    out (c),h                   ; 12 operand Y1 from H
    in h,(c)                    ; 12 result LSB to H
    add a,h
    ld h,a
    inc c                       ; 4  result MSB address
    in a,(c)                    ; 12 result MSB to A

    dec c                       ; 4  operand latch address
    out (c),e                   ; 12 operand Y2 from E
    in e,(c)                    ; 12 result LSB to E
    adc a,e
    ld e,a
    inc c                       ; 4  result MSB address
    in a,(c)                    ; 12 result MSB to A

    dec c                       ; 4  operand latch address
    out (c),d                   ; 12 operand Y3 from D
    in d,(c)                    ; 12 result LSB to D
    adc a,d
    ld d,a
    inc c                       ; 4  result MSB address
    in a,(c)                    ; 12 result MSB to A
    adc a,0                     ;    final carry

    ret
