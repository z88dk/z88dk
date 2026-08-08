;
;  feilipu, 2026 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 m32_fsdiv — N * (1/D); reciprocal in f32_fsinv (Newton–Raphson).
;

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsmul, m32_fsmul_callee
EXTERN m32_fsinv_fastcall

PUBLIC m32_fsdiv, m32_fsdiv_callee


.m32_fsdiv
    call m32_fsinv_fastcall
    jp m32_fsmul

.m32_fsdiv_callee
    call m32_fsinv_fastcall
    jp m32_fsmul_callee
