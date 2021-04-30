;
;       Generic pseudo graphics routines for text-only platforms
;
;       Xor pixel at (x,y) coordinate.


        SECTION code_clib
	PUBLIC	w_xorpixel
        EXTERN  __spc1000_mode
        defc    NEEDxor = 1



.w_xorpixel			
	INCLUDE "w_pixel.inc"
