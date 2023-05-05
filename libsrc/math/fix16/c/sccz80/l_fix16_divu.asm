

SECTION code_math

PUBLIC l_fix16_divu
EXTERN asm_fix16_divu


; Entry: hl = rhs
;        stack = lhs
l_fix16_divu:
    ex      de,hl
    pop     hl      ;Return address
    ex      (sp),hl
    jp      asm_fix16_divu
