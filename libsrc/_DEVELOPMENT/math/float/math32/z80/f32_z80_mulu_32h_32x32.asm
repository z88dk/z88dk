;
;  feilipu, 2019 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------
;
; multiplication of two 32-bit numbers into the high bytes of 64-bit product
;
; NOTE THIS IS NOT A TRUE MULTIPLY.
; Carry in from low bytes is not calculated.
; Rounding is done at 2^16.
;
; enter : dehl  = 32-bit multiplier   = x
;         dehl' = 32-bit multiplicand = y
;
; exit  : dehl = 32-bit product
;         carry reset
;
; uses  : af, bc, de, hl, af', bc', de', hl'

IF __CPU_Z80__

SECTION code_clib
SECTION code_fp_math32

EXTERN l_mulu_64_32x32

PUBLIC m32_mulu_32h_32x32

.m32_mulu_32h_32x32
    
    call l_mulu_64_32x32
    exx
    ld a,d
    exx

    or a
    ret Z                       ; exit  : use p3 to round p4 DEHL = 32-bit product
    set 0,l
    ret                         ; exit  : DEHL = 32-bit product
    
ENDIF
