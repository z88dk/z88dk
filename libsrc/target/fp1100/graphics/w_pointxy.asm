;
;       Generic pseudo graphics routines for text-only platforms
;
;       Point pixel at (x,y) coordinate.



        SECTION code_clib
        PUBLIC  w_pointxy
        EXTERN  __fp1100_mode
        defc    NEEDpoint= 1


.w_pointxy
    ld      a,(__fp1100_mode)
    bit     1,a
    jr      z,hires
    ld      h,l
    ld      l,e
    defc    WIDE_GFX = 1
    INCLUDE "gfx/gencon/pixel.inc"

hires:
	INCLUDE "w_pixel.inc"

