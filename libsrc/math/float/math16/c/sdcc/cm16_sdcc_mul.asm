; half __mul (half left, half right)
; Packed 11×11. SDCC stack: left, right, ret (caller cleans).

SECTION code_clib
SECTION code_fp_math16

PUBLIC cm16_sdcc_mul

EXTERN asm_f16_mul_callee

.cm16_sdcc_mul
    pop bc                      ; ret
    pop de                      ; left
    pop hl                      ; right
    push hl                     ; restore right
    push de                     ; restore left
    push de                     ; left for callee to consume
    push bc
    jp asm_f16_mul_callee

