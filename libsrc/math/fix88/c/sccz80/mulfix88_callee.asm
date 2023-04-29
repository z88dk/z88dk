

    SECTION code_clib

    PUBLIC  mulfix88_callee
    PUBLIC  _mulfix88_callee

    EXTERN  asm_fix88_mult


mulfix88_callee:
_mulfix88_callee:
    pop     bc
    pop     de
    pop     hl
    push    bc
    jp      asm_fix88_mult

