;
;  feilipu, 2020 May / 2026 August (8085)
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
;  asm_f16_div — 8085 half float divide: N * (1/D)
;-------------------------------------------------------------------------
; sccz80: HL = y, stack = [uret][x] → HL = x/y
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math16

EXTERN asm_f24_f16
EXTERN asm_f16_f24
EXTERN asm_f24_mul_callee
EXTERN asm_f24_mul_f24
EXTERN asm_f24_inv

PUBLIC asm_f16_div_callee
PUBLIC asm_f24_div_callee
PUBLIC asm_f24_div_f24


.asm_f16_div_callee
    call asm_f24_f16
    call asm_f24_inv
    push de
    push hl                     ; [inv][uret][x]
    ld de,sp+6
    ld hl,(de)
    call asm_f24_f16
    call asm_f24_mul_f24        ; drops inv; [uret][x]
    pop bc
    pop af
    push bc
    jp asm_f16_f24

.asm_f24_div_callee
.asm_f24_div_f24
    call asm_f24_inv
    jp asm_f24_mul_callee
