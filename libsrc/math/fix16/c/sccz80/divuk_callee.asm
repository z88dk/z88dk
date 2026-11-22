

    SECTION code_clib

    PUBLIC  divuk_callee
    PUBLIC  _divuk_callee

    EXTERN  asm_fix16_divu


divuk_callee:
_divuk_callee:
    pop     bc
    pop     de
    pop     hl
    push    bc
    jp      asm_fix16_divu

