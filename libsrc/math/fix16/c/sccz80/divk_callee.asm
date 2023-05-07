

    SECTION code_clib

    PUBLIC  divk_callee
    PUBLIC  _divk_callee

    EXTERN  asm_fix16_divs


divk_callee:
_divk_callee:
    pop     bc
    pop     de
    pop     hl
    push    bc
    jp      asm_fix16_divs

