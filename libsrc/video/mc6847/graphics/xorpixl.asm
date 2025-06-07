
    SECTION code_clib
    PUBLIC  xorpixel

    EXTERN  xor_MODE0
    EXTERN  xor_MODE1
    EXTERN  xor_MODE2

    EXTERN  __mc6847_mode
    INCLUDE "video/mc6847/mc6847.inc"


xorpixel:
    ld      a, (__mc6847_mode)
IF MC6847_HAS_HIRES
    cp      MODE_HIRES
    jp      z, xor_MODE1
ENDIF
    cp      MODE_MULTICOLOUR
    jp      z, xor_MODE2
    and     a
    ret     nz
    jp      xor_MODE0
