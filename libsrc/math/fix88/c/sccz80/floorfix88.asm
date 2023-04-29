

    SECTION code_clib

    PUBLIC  floorfix88
    PUBLIC  _floorfix88


floorfix88:
_floorfix88:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    inc     hl
    ld      l,a
floorfix88_fastcall:
_floorfix88_fastcall:
    ld      l,0
    dec     h
    ret
    
