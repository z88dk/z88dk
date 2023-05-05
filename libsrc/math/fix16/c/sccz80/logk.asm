

    SECTION code_clib

    PUBLIC  logk
    PUBLIC  _logk

    EXTERN  asm_fix16_log


logk:
_logk:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_log

