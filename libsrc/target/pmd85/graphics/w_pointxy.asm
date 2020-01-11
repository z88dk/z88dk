;
;       Generic pseudo graphics routines for text-only platforms
;
;       Point pixel at (x,y) coordinate.



        SECTION code_clib
	PUBLIC	w_pointxy
        EXTERN  __spc1000_mode
        defc    NEEDpoint= 1


.w_pointxy			
	INCLUDE "w_pixel.inc"

