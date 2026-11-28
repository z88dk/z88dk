
; Point pixel at (x,y)

    SECTION code_driver
    PUBLIC  w_pointxy
    EXTERN  __pc8001_gfxmode
    EXTERN  __pc8001_hires_point
    defc    NEEDpoint=1

w_pointxy:
    ld      a, (__pc8001_gfxmode)
    and     a
    jp      nz, __pc8001_hires_point
    INCLUDE "target/pc8001/graphics/pixel_SEMI.inc"
    ret
