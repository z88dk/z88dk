


    SECTION code_clib
    PUBLIC  getmaxy
    PUBLIC  _getmaxy
    EXTERN  __mc6847_mode
    EXTERN  __tms9918_getmaxy

    INCLUDE "classic/gfx/grafix.inc"
    INCLUDE "classic/video/mc6847/mc6847.inc"

getmaxy:
_getmaxy:
    ld      a, (__mc6847_mode)
    and     a
IF MODE0_3x2
    ld      hl, 47
ELIF MODE0_1x1
    ld      hl, 15
ELSE
    ld      hl, 31
ENDIF
    ret     z
IF FORspc1000
    cp      10
    jp      z, __tms9918_getmaxy
ENDIF
    ld      hl,MC6847_HIRES_YRES - 1
    ret
