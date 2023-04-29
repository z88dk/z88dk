

    SECTION code_clib

    PUBLIC  log2fix88
    PUBLIC  _log2fix88
    PUBLIC  log2fix88_fastcall
    PUBLIC  _log2fix88_fastcall

    EXTERN  asm_fix88_log2


log2fix88:
_log2fix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
log2fix88_fastcall:
_log2fix88_fastcall:
    jp      asm_fix88_log2

