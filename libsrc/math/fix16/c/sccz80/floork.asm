

    SECTION code_clib

    PUBLIC  floork
    PUBLIC  _floork


floork:
_floork:
    ld      hl,2
    add     hl,sp
    ld      a,(hl)
    inc     hl
    ld      h,(hl)
    inc     hl
    ld      l,a
floork_fastcall:
_floork_fastcall:
    ld      l,0
    ret
    
