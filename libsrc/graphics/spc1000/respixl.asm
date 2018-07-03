;
;       Generic pseudo graphics routines for text-only platforms
;
;       Reset pixel at (x,y) coordinate.



        SECTION code_clib
	PUBLIC	respixel
        EXTERN  __spc1000_mode
        defc    NEEDunplot = 1

dotext:
	ld	a,l
	cp	32
	ret	nc
        INCLUDE "graphics/generic_console/pixel.asm"


.respixel			
        ld      a,(__spc1000_mode)
        and     a
	jr	z,dotext
	INCLUDE "pixel.asm"

