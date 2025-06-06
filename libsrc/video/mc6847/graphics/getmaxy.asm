


    SECTION code_clib
    PUBLIC  getmaxy
    PUBLIC  _getmaxy
    EXTERN  __mc6847_mode

    INCLUDE "graphics/grafix.inc"
    INCLUDE "video/mc6847/mc6847.inc"

getmaxy:
_getmaxy:
    ld      a, (__mc6847_mode)
    and     a
    ld      hl, 47
    ret     z
    ld      hl, 191
    ret

