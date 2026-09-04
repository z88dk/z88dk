;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_ceil — IEEE single ceil
;-------------------------------------------------------------------------
;
; 8080-compatible (shared: 8080 / 8085 / gbz80)

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsadd_callee
EXTERN m32_discardfraction

PUBLIC m32_ceil_fastcall
PUBLIC _m32_ceilf

._m32_ceilf
.m32_ceil_fastcall
    call m32_discardfraction
    ret NC
    ld a,d
    and 080h
    ret NZ                      ; negative: trunc is ceil
    push de
    push hl
    ld de,$3f80
    ld hl,$0000
    call m32_fsadd_callee
    ret
