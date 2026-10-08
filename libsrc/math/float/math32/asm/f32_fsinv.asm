;
;  feilipu, 2026 October
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsinv_fastcall — restoring 1/x
;-------------------------------------------------------------------------
;
; Public reciprocal. The Newton–Raphson source is unchanged in
; asm/<cpu>/hist/f32_fsinv.asm. That directory is not assembled.
;
; enter : DEHL = x
; exit  : DEHL = 1/x
; uses  : af, bc, de, hl
;
; m32_fsdiv_callee wants the divisor in DEHL and the dividend in
; little-endian IEEE bytes under the return address. This entry
; pushes 1.0 (00 00 80 3F), reloads x, then calls that callee.

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsdiv_callee

PUBLIC m32_fsinv_fastcall
PUBLIC _m32_invf

._m32_invf
.m32_fsinv_fastcall
    push de                     ; x: b2, b3
    push hl                     ; x: b0, b1, b2, b3
    pop bc                      ; C=b0 B=b1
    pop de                      ; E=b2 D=b3

    ld hl,$3f80
    push hl                     ; 80, 3F
    ld hl,0
    push hl                     ; 00, 00, 80, 3F = 1.0

    push de                     ; x high under the low word
    push bc                     ; x: b0, b1, b2, b3, then 1.0
    pop hl                      ; HL = b1:b0
    pop de                      ; DE = b3:b2 ; stack = 1.0
    call m32_fsdiv_callee
    ret
