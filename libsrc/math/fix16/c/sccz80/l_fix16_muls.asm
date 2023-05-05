

SECTION code_math

PUBLIC l_fix16_muls
EXTERN asm_fix16_muls

; Entry: hl = rhs
;        stack = lhs
l_fix16_muls:
    ex      de,hl
    pop     hl      ;Return address
    ex      (sp),hl
    jp      asm_fix16_muls
