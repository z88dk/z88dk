;
;  2019 April feilipu
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

PUBLIC m32_mulu_32_16x16
    
.m32_mulu_32_16x16
    ld h,b                      ; xh
    ld l,d                      ; yh
    push hl                     ; xh yh
    
    ld l,e                      ; yl
    ld b,e                      ; yl
    ld e,c                      ; xl

    ; bc = xl yl
    ; de = xl yh
    ; hl = xh yl
    ; stack = xh yh

    mlt bc                      ; xl*yl
    mlt de                      ; xl*yh
    mlt hl                      ; xh*yl

    xor a                       ; zero A
    add hl,de                   ; sum cross products
    adc a,a                     ; capture carry
    ld d,a                      ; carry from cross products
    ld e,h                      ; LSB of MSW from cross products

    ld a,b
    add a,l
    ld b,a                      ; bc = final LSW

    pop hl
    mlt hl                      ; xh*yh
    adc hl,de                   ; hl = final MSW

    ret

