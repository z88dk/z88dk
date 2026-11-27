
    MODULE  pc8001_getmaxy
    SECTION code_clib
    PUBLIC  getmaxy
    PUBLIC  _getmaxy
    EXTERN  __console_h

; Four pixels per row: 100 high
getmaxy:
_getmaxy:
    ld      a, (__console_h)
    add     a
    add     a
    dec     a
    ld      l, a
    ld      h, 0
    ret
