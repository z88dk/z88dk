;
;  feilipu, 2019 April
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_ceil — IEEE single ceil
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsadd_callee
EXTERN m32_discardfraction

PUBLIC m32_ceil_fastcall
PUBLIC _m32_ceilf


; float ceilf(float f) __z88dk_fastcall;
._m32_ceilf

; Entry: dehl = floating point number
.m32_ceil_fastcall
    call m32_discardfraction
    ret NC                      ; already integer
    bit 7,d
    ret NZ                      ; negative -> trunc is ceil

    ; positive with fraction: trunc + 1
    ; Must CALL callee (not JP): fsadd_callee pops return address then left operand.
    push de
    push hl
    ld de,$3f80
    ld hl,$0000
    call m32_fsadd_callee
    ret
