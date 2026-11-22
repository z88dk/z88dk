


    SECTION code_clib
    PUBLIC  getmaxx
    PUBLIC  _getmaxx
    EXTERN  __mc6847_mode
    EXTERN  __tms9918_getmaxx
    EXTERN  __pc6001mk2_getmaxx

    INCLUDE "classic/gfx/grafix.inc"
    INCLUDE "classic/video/mc6847/mc6847.inc"

getmaxx:
_getmaxx:
    ld      a, (__mc6847_mode)
IF FORpc6001
    cp      MC6847_MODE_MK2
    jp      z, __pc6001mk2_getmaxx
ENDIF
    and     a
IF MODE0_3x2
    ld      hl, 63
ELIF MODE0_1x1
    ld      hl, 31
ELSE
    ld      hl, 63
ENDIF
    ret     z
IF MC6847_HAS_HIRES
    ld      hl, 255
    cp      1
    ret     z
ENDIF
IF FORspc1000
    cp      10
    jp      z, __tms9918_getmaxx
ENDIF
    ld      hl, 127
    ret

