
    SECTION code_clib
    
    PUBLIC  asm_fix88_pow
    EXTERN  _fix88_pow

; hl ^ de
asm_fix88_pow:
    push    hl
    push    de
    call    _fix88_pow
    ret
