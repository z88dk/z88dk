;
;       Generic pseudo graphics routines for text-only platforms
;
;       Reset pixel at (x,y) coordinate.



        SECTION code_clib
	PUBLIC	w_respixel
        EXTERN  __spc1000_mode
        defc    NEEDunplot = 1


.w_respixel			
	INCLUDE "w_pixel.inc"

