


    SECTION code_clib
    PUBLIC  getmaxx
    PUBLIC  _getmaxx
    EXTERN  __mc6847_mode

    INCLUDE "graphics/grafix.inc"
    INCLUDE "video/mc6847/mc6847.inc"

getmaxx:
_getmaxx:
    ld      a, (__mc6847_mode)
    and     a
IF MODE0_3x2
    ld      hl, 63
ELIF MODE0_1x1
    ld      hl, 31
ELSE
    ld      hl, 63
ENDIF
    ret     z
    ld      hl, 255
    cp      MODE_1
    ret     z
    ld      hl, 127
    ret

