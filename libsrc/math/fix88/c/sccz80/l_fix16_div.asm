

SECTION code_math

PUBLIC l_fix16_div
EXTERN asm_fix88_div


; Entry: hl = rhs
;        stack = lhs
l_fix16_div:
    ex      de,hl
    pop     hl      ;Return address
    ex      (sp),hl
    jp      asm_fix88_div