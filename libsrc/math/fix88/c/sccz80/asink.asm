

    SECTION code_clib

    PUBLIC  asink
    PUBLIC  _asink
    EXTERN  asm_fix16_asin


asink:
_asink:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    ld      l,a
    jp      asm_fix16_asin

