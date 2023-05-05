

SECTION code_math

PUBLIC l_fix16_mulu
EXTERN asm_fix16_mulu

; Entry: hl = rhs
;        stack = lhs
l_fix16_mulu:
    ex      de,hl
    pop     hl      ;Return address
    ex      (sp),hl
    jp      asm_fix16_mulu
