;
;       Plot pixel at (x,y) coordinate.



    SECTION code_clib
    PUBLIC  w_plotpixel
    defc    NEEDplot = 1
    defc    WIDE_GFX = 1
    EXTERN  __smc777_mode
    EXTERN  w_plotpixel_MODE4
    EXTERN  w_plotpixel_MODE8


.w_plotpixel			
    ld      a,(__smc777_mode)
    and     @00001100
    jr      nz,hires
    ld      h,l
    ld      l,e
    INCLUDE	"gfx/gencon/pixel.inc"

hires:
    cp      @00000100
    jp      z,w_plotpixel_MODE4
    jp      w_plotpixel_MODE8



