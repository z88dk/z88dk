;
;  feilipu, 2021 Apr
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------

IF __CPU_Z80__

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_l0_mulu_32h_24x24

PUBLIC m32_sqr_32h_24x24

;------------------------------------------------------------------------------
;
; square of two 24-bit numbers into a 32-bit product
;
; result is calculated for highest 32-bit result
; from a 48-bit calculation.
;
; Lower 8 bits intended to provide rounding information for
; IEEE floating point mantissa calculations.
;
; enter : abc = lde  = 24-bit multiplier  = x
;
; exit  : hlde  = 32-bit product
;
; uses  : af, bc, de, hl, bc', de', hl'


.m32_sqr_32h_24x24

    push hl                     ; preserve multiplicand
    push de

    push hl                     ; preserve multiplier
    push de

    ld a,e                      ; set up first multiplier from e

    jp m32_l0_mulu_32h_24x24    ; exit  : HLDE  = 32-bit product

ENDIF
