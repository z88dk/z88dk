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

PUBLIC l_lut_mulu_32_16x16

l_lut_mulu_32_16x16:

    ; multiplication of two 16-bit numbers into a 32-bit product
    ;
    ; enter : hl = 16-bit multiplier   = y
    ;         de = 16-bit multiplicand = x
    ;
    ; exit  : dehl = 32-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl

    ld c,d                      ; 4  c = x1
    ld b,h                      ; 4  b = y1
    push bc                     ; 11 preserve y1*x1

    ld c,e                      ; 4  c = x0
    ld b,l                      ; 4  b = y0
    push bc                     ; 11 preserve y0*x0

;;; MLT HE (xBC) ;;;;;;;;;;;;;;;; y1*x0
    ld c,__IO_LUT_OPERAND_LATCH ; 7  operand latch address
    ld b,h                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from E
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H

;;; MLT DL (xBC) ;;;;;;;;;;;;;;;; x1*y0
    dec c                       ; 4  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D

    xor a                       ; 4  zero A
    add hl,de                   ; 11 add cross products
    adc a,a                     ; 4  capture carry

    pop de                      ; 10 restore y0*x0

;;; MLT DE (xBC) ;;;;;;;;;;;;;;;; y0*x0
    dec c                       ; 4  operand latch address
    ld b,d                      ; 4  operand Y in B
    out (c),e                   ; 12 operand X from A
    in e,(c)                    ; 12 result Z LSB to E
    inc c                       ; 4  result MSB address
    in d,(c)                    ; 12 result Z MSB to D

    ld b,a                      ; 4  carry from cross products

    ld a,d                      ; 4
    add a,l                     ; 4
    ld d,a                      ; 4  DE = final LSW

    ld l,h                      ; 4  LSB of MSW from cross products
    ld h,b                      ; 4  carry from cross products

    ex (sp),hl                  ; 19 restore y1*x1, stack interim p3 p2

;;; MLT HL (xBC) ;;;;;;;;;;;;;;;; x1*y1
    dec c                       ; 4  operand latch address
    ld b,h                      ; 4  operand Y in B
    out (c),l                   ; 12 operand X from L
    in l,(c)                    ; 12 result Z LSB to L
    inc c                       ; 4  result MSB address
    in h,(c)                    ; 12 result Z MSB to H
    
    pop bc                      ; 10 destack interim p3 p2

    adc hl,bc                   ; 15 hl = final MSW
    ex de,hl                    ; 4  DEHL = final product
    ret
