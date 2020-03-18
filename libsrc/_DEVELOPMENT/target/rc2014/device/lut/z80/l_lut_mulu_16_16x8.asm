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

PUBLIC l_lut_mulu_16_16x8

    ex de,hl

l_lut_mulu_16_16x8:

    ; multiplication of a 16-bit number by an 8-bit number into 16-bit product
    ;
    ; enter :  l =  8-bit multiplier
    ;         de = 16-bit multiplicand
    ;
    ; exit  : hl = 16-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    ld c,__IO_LUT_OPERAND_LATCH ; operand latch address

    ld b,l
    out (c),e                   ; multiply lsb
    in l,(c)                    ; lsb
    inc c
    in h,(c)                    ; msb
 
    dec c                       ; operand latch address
    out (c),d
    in a,(c)

    add a,h                     ; add to msb final
    ld h,a                      ; hl = final

    xor a
    ret
