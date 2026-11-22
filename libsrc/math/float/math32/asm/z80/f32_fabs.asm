;
;  feilipu, 2019 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fabs — IEEE single absolute value
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

PUBLIC  m32_fabs_fastcall
PUBLIC _m32_fabsf


._m32_fabsf
.m32_fabs_fastcall
    res 7,d
    ret
