
    SECTION code_clib
    PUBLIC  pointxy

    EXTERN  pointxy_MODE0
    EXTERN  pointxy_MODE1
    EXTERN  pointxy_MODE2

    EXTERN  __tms9918_pointxy
    EXTERN  __mc6847_mode
    INCLUDE "video/mc6847/mc6847.inc"


pointxy:
    ld      a, (__mc6847_mode)
IF FORspc1000
    cp      10
    jp      z,__tms9918_pointxy
ENDIF
    and     0xfd
IF MC6847_HAS_HIRES
    cp      MODE_HIRES & 0xfd
    jp      z, pointxy_MODE1
ENDIF
    cp      MODE_MULTICOLOUR & 0xfd
    jp      z, pointxy_MODE2
IF MC6847_HAS_TEXT_GFX
    and     a
    ret     nz
    jp      pointxy_MODE0
ENDIF