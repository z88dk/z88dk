

SECTION code_math

PUBLIC l_fix16_divs
EXTERN asm_fix16_divs


; Entry: hl = rhs
;        stack = lhs
l_fix16_divs:
    ex      de,hl
    pop     hl      ;Return address
    ex      (sp),hl
    jp      asm_fix16_divs
