    INCLUDE	"graphics/grafix.inc"


    SECTION   code_clib
    PUBLIC    getmaxy
    PUBLIC    _getmaxy
    EXTERN	__z1013_mode
    EXTERN  CONSOLE_ROWS

.getmaxy
._getmaxy
    ld      a,(__z1013_mode)
    and     a
    ld      hl, +(CONSOLE_ROWS * 2) - 1
    ret     z
    ld      hl, 255
    ret
