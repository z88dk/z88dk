;
;       Plot pixel at (x,y) coordinate.



    SECTION code_clib
    PUBLIC  w_xorpixel
    EXTERN  xor_MODE0
    EXTERN  xor_MODE6
    EXTERN  xor_MODE64
    EXTERN  xor_MODE128

    EXTERN  __zx_gfxmode
    defc    NEEDxor=1


w_xorpixel:
    ld      a, (__zx_gfxmode)
    cp      3
    jp      c, xor_MODE0
IF    FORzxn
    bit     6, a
    jp      nz, xor_MODE64
    bit     7, a
    jp      nz, xor_MODE128
ENDIF
    jp      xor_MODE6



