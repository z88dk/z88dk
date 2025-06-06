
    SECTION code_clib
    PUBLIC  respixel

    EXTERN  res_MODE0
    EXTERN  res_MODE1
    EXTERN  res_MODE2

    EXTERN  __mc6847_mode
    INCLUDE "video/mc6847/mc6847.inc"


respixel:
    ld      a, (__mc6847_mode)
    cp      MODE_1
    jp      z, res_MODE1
    cp      MODE_2
    jp      z, res_MODE2
    and     a
    ret     nz
    jp      res_MODE0
