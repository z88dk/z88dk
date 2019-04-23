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

SECTION code_clib
SECTION code_math

EXTERN l_mulu_32_16x16

PUBLIC m32_mulu_32_16x16

.m32_mulu_32_16x16
    ld h,b
    ld l,c

    ; compute:  dehl = hl * de
    ; alters :  af, bc, de, hl
    call l_mulu_32_16x16

    ex de,hl
    ld b,d
    ld c,e

    ret

