
    SECTION code_clib
    
    PUBLIC  asm_fix16_pow
    EXTERN  _fix16_pow

; hl ^ de
asm_fix16_pow:
    push    hl
    push    de
    call    _fix16_pow
    ret
