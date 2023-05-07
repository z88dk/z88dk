

    SECTION code_clib

    PUBLIC  tanhk
    PUBLIC  _tanhk
    EXTERN  asm_fix16_tanh


tanhk:
_tanhk:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_tanh

