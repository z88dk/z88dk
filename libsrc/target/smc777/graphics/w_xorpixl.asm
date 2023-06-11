;
;       Xor-Plot pixel at (x,y) coordinate.



    SECTION code_clib
    PUBLIC  w_xorpixel
    defc    NEEDxor = 1
    defc    WIDE_GFX = 1
    EXTERN  __smc777_mode
    EXTERN  w_xorpixel_MODE4
    EXTERN  w_xorpixel_MODE8


.w_xorpixel			
    ld      a,(__smc777_mode)
    and     @00001100
    jr      nz,hires
    ld      h,l
    ld      l,e
    INCLUDE	"gfx/gencon/pixel.inc"

hires:
    cp      @00000100
    jp      z,w_xorpixel_MODE4
    jp      w_xorpixel_MODE8



