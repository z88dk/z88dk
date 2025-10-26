
    SECTION code_clib
    PUBLIC  respixel

    EXTERN  res_MODE0
    EXTERN  res_MODE1
    EXTERN  res_MODE2

    EXTERN  __mc6847_mode
    EXTERN  __tms9918_respixel
    INCLUDE "classic/video/mc6847/mc6847.inc"


respixel:
    ld      a, (__mc6847_mode)
IF FORspc1000
    cp      10
    jp      z,__tms9918_respixel
ENDIF
IF MC6847_HAS_HIRES
    cp      1
    jp      z, res_MODE1
ENDIF
IF MC6847_HAS_CG
    cp      2
    jp      z, res_MODE2
ENDIF
IF MC6847_HAS_TEXT_GFX
    and     a
    ret     nz
    jp      res_MODE0
ELSE   
    ret
ENDIF
