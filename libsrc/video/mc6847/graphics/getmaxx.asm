


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
    ld      hl, +63
    ret     z
    ld      hl, 255
    cp      MODE_1
    ret     z
    ld      hl, 127
    ret

