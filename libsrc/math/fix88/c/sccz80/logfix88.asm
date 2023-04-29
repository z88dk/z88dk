

    SECTION code_clib

    PUBLIC  logfix88
    PUBLIC  _logfix88

    EXTERN  asm_fix88_log


logfix88:
_logfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix88_log

