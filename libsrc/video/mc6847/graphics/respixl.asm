
    SECTION code_clib
    PUBLIC  respixel

    EXTERN  res_MODE0
    EXTERN  res_MODE1
    EXTERN  res_MODE2

    EXTERN  __mc6847_mode
    EXTERN  __tms9918_respixel
    INCLUDE "video/mc6847/mc6847.inc"


respixel:
    ld      a, (__mc6847_mode)
IF FORspc1000
    cp      10
    jp      z,__tms9918_respixel
ENDIF
    and     0xfd
IF MC6847_HAS_HIRES
    cp      MODE_HIRES & 0xfd
    jp      z, res_MODE1
ENDIF
    cp      MODE_MULTICOLOUR & 0xfd
    jp      z, res_MODE2
IF MC6847_HAS_TEXT_GFX
    and     a
    ret     nz
    jp      res_MODE0
ELSE   
    ret
ENDIF
