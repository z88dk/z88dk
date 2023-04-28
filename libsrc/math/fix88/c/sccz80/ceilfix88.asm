

    SECTION code_clib

    PUBLIC  ceilfix88
    PUBLIC  _ceilfix88


ceilfix88:
_ceilfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    inc     hl
    ld      l,a
ceilfix88_fastcall:
_ceilfix88_fastcall:
    ld      l,0
    inc     h
    ret
    
