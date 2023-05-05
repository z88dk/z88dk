

    SECTION code_clib

    PUBLIC  log2k
    PUBLIC  _log2k

    EXTERN  asm_fix16_log2


log2k:
_log2k:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_log2

