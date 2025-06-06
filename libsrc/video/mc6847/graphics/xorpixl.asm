
    SECTION code_clib
    PUBLIC  xorpixel

    EXTERN  xor_MODE0
    EXTERN  xor_MODE1
    EXTERN  xor_MODE2

    EXTERN  __mc6847_mode
    INCLUDE "video/mc6847/mc6847.inc"


xorpixel:
    ld      a, (__mc6847_mode)
    cp      MODE_1
    jp      z, xor_MODE1
    cp      MODE_2
    jp      z, xor_MODE2
    and     a
    ret     nz
    jp      xor_MODE0
