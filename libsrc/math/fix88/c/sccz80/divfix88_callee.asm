

    SECTION code_clib

    PUBLIC  divfix88_callee
    PUBLIC  _divfix88_callee

    EXTERN  asm_fix88_div


divfix88_callee:
_divfix88_callee:
    pop     bc
    pop     de
    pop     hl
    push    bc
    jp      asm_fix88_div

