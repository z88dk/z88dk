

    SECTION code_clib

    PUBLIC  ceilk
    PUBLIC  _ceilk


ceilk:
_ceilk:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    inc     hl
    ld      l,a
ceilk_fastcall:
_ceilk_fastcall:
    ld      l,0
    inc     h
    ret
    
