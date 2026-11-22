; half __mul (half left, half right)
; Packed 11×11, same as l_f16_mul / 8080 mulf16.

SECTION code_clib
SECTION code_fp_math16

PUBLIC cm16_sccz80_mul

EXTERN asm_f16_mul_callee

.cm16_sccz80_mul
    ; enter : stack = left, right, ret
    ; exit  :    HL = left*right
    pop bc                      ; ret
    pop hl                      ; right
    push bc                     ; ret; left remains
    jp asm_f16_mul_callee
