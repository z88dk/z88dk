;
;  feilipu, 2026 October
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; asm_f16_inv — restoring 1/x
;-------------------------------------------------------------------------
;
; Public reciprocal. The Newton–Raphson source is unchanged in
; asm/<cpu>/hist/asm_f16_inv.asm. That directory is not assembled.
;
; enter : HL = x
; exit  : HL = 1/x
; uses  : af, bc, de, hl
;
; asm_f16_div_callee wants the divisor in HL and the dividend half
; under the return address. Half 1.0 is 0x3C00.

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f16_div_callee

PUBLIC asm_f16_inv

.asm_f16_inv
    push hl                     ; x
    ld hl,$3c00                 ; 1.0
    ex de,hl
    pop hl                      ; HL = x
    push de                     ; stack = 1.0
    call asm_f16_div_callee
    ret
