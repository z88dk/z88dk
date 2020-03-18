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

PUBLIC l_lut_mulu_16_8x8

l_lut_mulu_16_8x8:

    ; multiplication of a 8-bit number by an 8-bit number into 16-bit product
    ;
    ; enter :  l =  8-bit multiplier
    ;          e =  8-bit multiplicand
    ;
    ; exit  : hl = 16-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address

    ld b,e                      ; 4  operand Y to B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H

    ret
