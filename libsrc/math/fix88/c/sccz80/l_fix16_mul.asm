

SECTION code_math

PUBLIC l_fix16_mul
EXTERN asm_fix88_mult

; Entry: hl = rhs
;        stack = lhs
l_fix16_mul:
    ex      de,hl
    pop     hl      ;Return address
    ex      (sp),hl
    jp      asm_fix88_mult