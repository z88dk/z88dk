

    SECTION code_clib

    PUBLIC  muluk_callee
    PUBLIC  _muluk_callee

    EXTERN  asm_fix16_mulu


muluk_callee:
_muluk_callee:
    pop     bc
    pop     de
    pop     hl
    push    bc
    jp      asm_fix16_mulu

