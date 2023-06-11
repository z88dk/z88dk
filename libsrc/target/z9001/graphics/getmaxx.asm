    INCLUDE	"graphics/grafix.inc"


    SECTION   code_clib
    PUBLIC    getmaxx
    PUBLIC    _getmaxx
    EXTERN	__z9001_mode
    EXTERN  CONSOLE_COLUMNS

.getmaxx
._getmaxx
    ld      a,(__z9001_mode)
    and     a
    ld      hl, +(CONSOLE_COLUMNS * 2) - 1
    ret	    z
    ld	    hl, 319
    ret
