    INCLUDE	"graphics/grafix.inc"


    SECTION   code_clib
    PUBLIC    getmaxx
    PUBLIC    _getmaxx
    EXTERN	__z1013_mode
    EXTERN  CONSOLE_COLUMNS

.getmaxx
._getmaxx
    ld      a,(__z1013_mode)
    and     a
    ld      hl, +(CONSOLE_COLUMNS * 2) - 1
    ret	    z
    ld	    hl, 255
    ret
