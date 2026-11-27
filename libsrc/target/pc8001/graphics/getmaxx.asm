
    MODULE  pc8001_getmaxx
    SECTION code_clib
    PUBLIC  getmaxx
    PUBLIC  _getmaxx
    EXTERN  __console_w

; Two pixels per column: 160 wide in 80 column mode
getmaxx:
_getmaxx:
    ld      a, (__console_w)
    add     a
    dec     a
    ld      l, a
    ld      h, 0
    ret
