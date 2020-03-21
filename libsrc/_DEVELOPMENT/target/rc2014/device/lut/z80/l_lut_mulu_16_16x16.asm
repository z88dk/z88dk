;
;  feilipu, 2020 March
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

PUBLIC l_lut_mulu_16_16x16

l_lut_mulu_16_16x16:

    ; multiplication of two 16-bit numbers into a 16-bit product
    ;
    ; enter : hl = 16-bit multiplier   = y
    ;         de = 16-bit multiplicand = x
    ;
    ; exit  : hl = 16-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    ld c,e                      ; 4  c = xl
    ld b,l                      ; 4  b = yl
    push bc                     ; 11 preserve yl*xl

    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address

                                ; yh*xl
    ld b,h                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E

                                ; xh*yl
    ld b,d                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in a,(c)                    ; 12 result Z LSB to A

    add a,e                     ; 4  add cross products LSB
    pop hl                      ; 10 restore yl*xl

                                ; yl*xl
    ld b,h                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L

    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H

    add a,h                     ; 4  add to msb final
    ld h,a                      ; 4  hl = final

    xor a                       ; 4  reset carry
    ret
