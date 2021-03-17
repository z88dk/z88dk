    SECTION code_clib
    PUBLIC  w_xorpixel


    EXTERN  xor_MODE0
    EXTERN  xor_MODE2
    EXTERN  xor_MODE3
    EXTERN  xor_MODE4
    EXTERN  __zx_screenmode
    defc    NEEDxor = 1


w_xorpixel:
    ld      a,(__zx_screenmode)
    and     a
    jp      z,xor_MODE0
    dec     a
    jp      z,xor_MODE2
    dec     a
    jp      z,xor_MODE3
    jp      xor_MODE4