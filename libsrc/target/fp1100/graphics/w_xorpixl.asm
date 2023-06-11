;
;       Generic pseudo graphics routines for text-only platforms
;
;       Xor pixel at (x,y) coordinate.


        SECTION code_clib
        PUBLIC	w_xorpixel
        EXTERN  __fp1100_mode
        defc    NEEDxor = 1



.w_xorpixel
    ld      a,(__fp1100_mode)
    bit     1,a
    jr      z,hires
    ld      h,l
    ld      l,e
    defc    WIDE_GFX = 1
    INCLUDE "gfx/gencon/pixel.inc"

hires:	
	INCLUDE "w_pixel.inc"
