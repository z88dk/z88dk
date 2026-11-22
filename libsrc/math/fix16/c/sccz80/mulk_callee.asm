

    SECTION code_clib

    PUBLIC  mulk_callee
    PUBLIC  _mulk_callee

    EXTERN  asm_fix16_muls


mulk_callee:
_mulk_callee:
    pop     bc
    pop     de
    pop     hl
    push    bc
    jp      asm_fix16_muls

