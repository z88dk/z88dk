;
;  feilipu, 2020 May / 2026 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_div - z80 half floating point divide
;-------------------------------------------------------------------------
;
; R = N * (1/D).  Reciprocal: asm_f24_inv in asm_f16_inv.asm (NR).
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24

EXTERN asm_f24_mul_f24
EXTERN asm_f24_mul_callee
EXTERN asm_f24_inv

PUBLIC asm_f16_div_callee
PUBLIC asm_f24_div_callee


; enter here for floating asm_f16_div_callee, x/y, x on stack, y in hl, result in hl
.asm_f16_div_callee
    call asm_f24_f16            ; expand to dehl
    call asm_f24_inv
    exx                         ; 1/y
    pop hl                      ; pop return address
    ex (sp),hl                  ; get second operand off of the stack,
                                ; return address on stack
    call asm_f24_f16            ; expand to dehl
    call asm_f24_mul_f24
    jp asm_f16_f24


; enter here for floating asm_f24_div_callee, x/y, x on stack, y in dehl, result in dehl
.asm_f24_div_callee
    call asm_f24_inv
    jp asm_f24_mul_callee
