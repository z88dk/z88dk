;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 IEEE fabs — clear sign bit (no Z80 RES)

SECTION code_clib
SECTION code_fp_math32

PUBLIC  m32_fabs_fastcall
PUBLIC _m32_fabsf

._m32_fabsf
.m32_fabs_fastcall
    ld a,d
    and 07fh
    ld d,a
    ret
