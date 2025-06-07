
    SECTION code_clib
    PUBLIC  pointxy

    EXTERN  pointxy_MODE0
    EXTERN  pointxy_MODE1
    EXTERN  pointxy_MODE2

    EXTERN  __mc6847_mode
    INCLUDE "video/mc6847/mc6847.inc"


pointxy:
    ld      a, (__mc6847_mode)
IF MC6847_HAS_HIRES
    cp      MODE_HIRES
    jp      z, pointxy_MODE1
ENDIF
    cp      MODE_MULTICOLOUR
    jp      z, pointxy_MODE2
    and     a
    ret     nz
    jp      pointxy_MODE0
