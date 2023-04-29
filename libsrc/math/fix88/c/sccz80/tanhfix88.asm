

    SECTION code_clib

    PUBLIC  tanhfix88
    PUBLIC  _tanhfix88
    EXTERN  asm_fix88_tanh


tanhfix88:
_tanhfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix88_tanh

