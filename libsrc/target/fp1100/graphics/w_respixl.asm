;
;       Generic pseudo graphics routines for text-only platforms
;
;       Reset pixel at (x,y) coordinate.



        SECTION code_clib
        PUBLIC	w_respixel
        EXTERN  __fp1100_mode
        defc    NEEDunplot = 1


.w_respixel
    ld      a,(__fp1100_mode)
    bit     1,a
    jr      z,hires
    ld      h,l
    ld      l,e
    INCLUDE "graphics/generic_console/pixel.inc"

hires:	
	INCLUDE "w_pixel.inc"

