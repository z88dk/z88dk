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

SECTION code_driver

PUBLIC asm_lut_read

;------------------------------------------------------------------------------
;
; Read RC2014 LUT Module
;
; entry : hl = 16-bit linear address or 8-bit x 8-bit table address
;
; exit  : hl = 16-bit result
;
; uses  : bc

.asm_lut_read

    ld b,h                      ; 4  operand Y in B
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H
    ret                         ; 10

