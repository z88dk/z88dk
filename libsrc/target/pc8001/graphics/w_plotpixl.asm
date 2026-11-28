
; Plot pixel at (x,y)

    SECTION code_driver
    PUBLIC  w_plotpixel
    EXTERN  __pc8001_gfxmode
    EXTERN  __pc8001_hires_plot
    defc    NEEDplot=1

w_plotpixel:
    ld      a, (__pc8001_gfxmode)
    and     a
    jp      nz, __pc8001_hires_plot
    INCLUDE "target/pc8001/graphics/pixel_SEMI.inc"
    ret
