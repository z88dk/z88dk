;
;       Generic pseudo graphics routines for text-only platforms
;
;       Point pixel at (x,y) coordinate.



    SECTION code_clib
    PUBLIC  w_pointxy
    EXTERN  __smc777_mode
    defc    NEEDpoint= 1
    defc    WIDE_GFX = 1
    EXTERN  w_pointxy_MODE4
    EXTERN  w_pointxy_MODE8


.w_pointxy			
        ld      a,(__smc777_mode)
        and     @00001100
        jr      nz,hires
        ld      h,l
        ld      l,e
        INCLUDE "gfx/gencon/pixel.inc"

hires:
        cp      @00000100
        jp      z,w_pointxy_MODE4
        jp      w_pointxy_MODE8
