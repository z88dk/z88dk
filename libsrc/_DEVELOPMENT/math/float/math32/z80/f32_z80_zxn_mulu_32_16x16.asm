;
;  feilipu, 2019 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------
;
; multiplication of two 16-bit numbers into a 32-bit product
;
; enter : bc = 16-bit multiplier   = x
;         de = 16-bit multiplicand = y
;
; exit  : hlbc = 32-bit product
;
; uses  : af, bc, de, hl

SECTION code_clib
SECTION code_math

PUBLIC m32_mulu_32_16x16

.m32_mulu_32_16x16
    ld h,b                      ; xh
    ld l,d                      ; yh
    push hl                     ; xh yh
    
    ld l,e                      ; yl
    ld e,c                      ; xl
    ld b,l                      ; yl

    ; bc = yl xl 
    ; de = yh xl
    ; hl = xh yl
    ; stack = xh yh

    mul de                      ; xl*yh
    ex de,hl
    mul de                      ; xh*yl

    xor a                       ; zero A
    add hl,de                   ; sum cross products
    adc a,a                     ; capture carry

    ld e,c
    ld d,b
    mul de                      ; xl*yl

    ld b,a                      ; carry from cross products
    ld c,h                      ; LSB of MSW from cross products

    ld a,d
    add a,l
    ld h,a
    ld l,e                      ; hl = LSW

    pop de
    mul de                      ; xh*yh

    ex de,hl                    ; de = final LSW
    adc hl,bc                   ; hl = final MSW

    ld b,d
    ld c,e                      ; hlbc = final result

    ret

