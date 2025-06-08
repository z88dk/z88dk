


    SECTION code_clib
    PUBLIC  getmaxy
    PUBLIC  _getmaxy
    EXTERN  __mc6847_mode

    INCLUDE "graphics/grafix.inc"
    INCLUDE "video/mc6847/mc6847.inc"

getmaxy:
_getmaxy:
    ld      a, (__mc6847_mode)
    and     @11111101
IF MODE0_3x2
    ld      hl, 47
ELIF MODE0_1x1
    ld      hl, 15
ELSE
    ld      hl, 31
ENDIF
    ret     z
IF FORsv8000
    ld      de, 95
ELIF FORvz
    ld      de, 63
ELSE
    ld      hl, 191
ENDIF
    ret

