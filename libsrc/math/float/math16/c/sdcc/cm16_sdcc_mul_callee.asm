; half __mul_callee (half left, half right)
; Packed 11×11. SDCC stack: left, right, ret.

SECTION code_clib
SECTION code_fp_math16

PUBLIC cm16_sdcc_mul_callee

EXTERN asm_f16_mul_callee

.cm16_sdcc_mul_callee
    pop bc                      ; ret
    pop de                      ; left
    pop hl                      ; right
    push de                     ; left
    push bc
    jp asm_f16_mul_callee

