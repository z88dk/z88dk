;
;  2019 April feilipu
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;------------------------------------------------------------------------------
;
; multiplication of two 32-bit numbers into a 32-bit product
;
; enter : dehl  = 32-bit multiplier   = x
;         dehl' = 32-bit multiplicand = y
;
; exit  : dehl = 32-bit product
;
; uses  : af, bc, de, hl, af', bc', de', hl'

SECTION code_clib
SECTION code_math

EXTERN l_mulu_64_32x32

PUBLIC m32_mulu_32h_32x32

defc m32_mulu_32h_32x32 = l_mulu_64_32x32

