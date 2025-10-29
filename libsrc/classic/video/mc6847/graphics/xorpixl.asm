
    SECTION code_clib
    PUBLIC  xorpixel

    EXTERN  xor_MODE0
    EXTERN  xor_MODE1
    EXTERN  xor_MODE2

    EXTERN  __mc6847_mode
    EXTERN  __tms9918_xorpixel
    INCLUDE "classic/video/mc6847/mc6847.inc"


xorpixel:
    ld      a, (__mc6847_mode)
IF FORspc1000
    cp      10
    jp      z,__tms9918_xorpixel
ENDIF
IF MC6847_HAS_HIRES
    cp      1
    jp      z, xor_MODE1
ENDIF
IF MC6847_HAS_CG
    cp      2
    jp      z, xor_MODE2
ENDIF
IF MC6847_HAS_TEXT_GFX
    and     a
    ret     nz
    jp      xor_MODE0
ELSE
    ret
ENDIF
