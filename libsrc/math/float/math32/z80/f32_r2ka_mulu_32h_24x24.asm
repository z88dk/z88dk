;
;  feilipu, 2023 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------

IF  __CPU_RABBIT__

SECTION code_clib
SECTION code_fp_math32

EXTERN l_mulu_64_32x32

PUBLIC m32_mulu_32h_24x24

;------------------------------------------------------------------------------
;
; multiplication of two 24-bit numbers into a 32-bit high product
;
; result is calculated for highest 32-bit result
; from a 48-bit calculation.
;
; lower 8 bits intended to provide rounding information for
; IEEE floating point 24-bit mantissa calculations.
;
; enter :  lde  = 24-bit multiplicand = x
;          lde' = 24-bit multiplier   = y
;
; exit  : hlde  = 32-bit product
;
; uses  : af, bc, de, hl, bc', de', hl'


.m32_mulu_32h_24x24

    ld h,e                      ; shift to high order of 64_32x32
    ld e,d                      ; 0lde -> deh0
    ld d,l
    ld l,0
    exx

    ld h,e                      ; shift to high order of 64_32x32
    ld e,d                      ; 0lde -> deh0
    ld d,l
    ld l,0

    ; multiplication of two 32-bit numbers into a 64-bit product
    ;
    ; enter : de hl = 32-bit multiplicand = x
    ;         de'hl'= 32-bit multiplier   = y
    ;
    ; exit  : dehl dehl' = 64-bit product
    ;         carry reset
    ;
    ; uses  : af, bc, de, hl, bc', de', hl'

    call l_mulu_64_32x32

    ex de,hl
    ret                         ; exit  : HLDE  = 32-bit high product

ENDIF
