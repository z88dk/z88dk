;
;       Generic pseudo graphics routines for text-only platforms
;
;       Point pixel at (x,y) coordinate.



        SECTION code_clib
	PUBLIC	pointxy
        EXTERN  __spc1000_mode
        defc    NEEDpoint= 1

dotext:
	ld	a,l
	cp	32
	ret	nc
        INCLUDE "graphics/generic_console/pixel.asm"


.pointxy			
        ld      a,(__spc1000_mode)
        and     a
        jr      z,dotext
	INCLUDE "pixel.asm"

