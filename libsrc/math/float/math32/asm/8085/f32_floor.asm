;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
; 8085 floorf

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fssub_callee
EXTERN m32_discardfraction

PUBLIC m32_floor_fastcall
PUBLIC _m32_floorf

._m32_floorf
.m32_floor_fastcall
    call m32_discardfraction
    ret NC
    ld a,d
    and 080h
    ret Z                       ; positive: trunc is floor
    push de
    push hl
    ld de,$3f80
    ld hl,$0000
    jp m32_fssub_callee
