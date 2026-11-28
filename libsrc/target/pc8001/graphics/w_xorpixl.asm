
; Xor pixel at (x,y)

    SECTION code_driver
    PUBLIC  w_xorpixel
    EXTERN  __pc8001_gfxmode
    EXTERN  __pc8001_hires_xor
    defc    NEEDxor=1

w_xorpixel:
    ld      a, (__pc8001_gfxmode)
    and     a
    jp      nz, __pc8001_hires_xor
    INCLUDE "target/pc8001/graphics/pixel_SEMI.inc"
    ret
