    SECTION code_clib
    PUBLIC  w_xorpixel


    EXTERN  xor_MODE0
    EXTERN  xor_MODE1
    EXTERN  xor_MODE2
    EXTERN  __cpc_mode
    defc    NEEDxor = 1


w_xorpixel:
    ld      a,d      ;Check y
    and     a
    ret     nz
    ld      a,e
    cp      200
    ret     nc
    ld      a,(__cpc_mode)
    and     a
    jp      z,xor_MODE0
    dec     a
    jp      z,xor_MODE1
    jp      xor_MODE2