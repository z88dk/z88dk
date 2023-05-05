

    SECTION code_clib

    PUBLIC  powk_callee
    PUBLIC  _powk_callee

    EXTERN  asm_fix16_pow


powk_callee:
_powk_callee:
    pop     bc
    pop     de
    pop     hl
    push    bc
    jp      asm_fix16_pow

