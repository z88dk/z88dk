

    SECTION code_clib

    PUBLIC  logfix88
    PUBLIC  _logfix88
    PUBLIC  logfix88_fastcall
    PUBLIC  _logfix88_fastcall

    EXTERN  asm_fix88_log


logfix88:
_logfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
logfix88_fastcall:
_logfix88_fastcall:
    jp      asm_fix88_log

