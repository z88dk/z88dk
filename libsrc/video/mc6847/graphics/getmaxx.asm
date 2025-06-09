


    SECTION code_clib
    PUBLIC  getmaxx
    PUBLIC  _getmaxx
    EXTERN  __mc6847_mode

    INCLUDE "graphics/grafix.inc"
    INCLUDE "video/mc6847/mc6847.inc"

getmaxx:
_getmaxx:
    ld      a, (__mc6847_mode)
    and     @11111101
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
    cp      MODE_HIRES & 0xfd
    ret     z
ENDIF
    ld      hl, 127
    ret

