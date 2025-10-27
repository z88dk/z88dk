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

PUBLIC m32_mulu_32h_32x32

;------------------------------------------------------------------------------
;
; multiplication of two 32-bit numbers into the high bytes of 64-bit product
;
;
; enter : dehl  = 32-bit multiplicand  = x   x1x0
;         dehl' = 32-bit multiplier    = y   y1y0
;
; exit  : dehl  = 32-bit product = z  z3z2 = y1y0 * x1x0
;         carry reset
;
; uses  : af, bc, de, hl, bc', de', hl'


defc m32_mulu_32h_32x32 = l_mulu_64_32x32

                                ; exit  : DEHL = 32-bit product

ENDIF
