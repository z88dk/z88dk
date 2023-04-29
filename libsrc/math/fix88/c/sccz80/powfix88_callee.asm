

    SECTION code_clib

    PUBLIC  powfix88_callee
    PUBLIC  _powfix88_callee

    EXTERN  asm_fix88_pow


powfix88_callee:
_powfix88_callee:
    pop     bc
    pop     de
    pop     hl
    push    bc
    jp      asm_fix88_pow

