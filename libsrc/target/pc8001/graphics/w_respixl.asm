
; Unplot pixel at (x,y)

    SECTION code_driver
    PUBLIC  w_respixel
    EXTERN  __pc8001_gfxmode
    EXTERN  __pc8001_hires_unplot
    defc    NEEDunplot=1

w_respixel:
    ld      a, (__pc8001_gfxmode)
    and     a
    jp      nz, __pc8001_hires_unplot
    INCLUDE "target/pc8001/graphics/pixel_SEMI.inc"
    ret
