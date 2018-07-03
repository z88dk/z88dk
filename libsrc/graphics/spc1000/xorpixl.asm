;
;       Generic pseudo graphics routines for text-only platforms
;
;       Xor pixel at (x,y) coordinate.


        SECTION code_clib
	PUBLIC	xorpixel
        EXTERN  __spc1000_mode
        defc    NEEDxor = 1

dotext:
	ld	a,l
	cp	32
	ret	nc
        INCLUDE "graphics/generic_console/pixel.asm"


.xorpixel			
        ld      a,(__spc1000_mode)
        and     a
        jr      z,dotext
	INCLUDE "pixel.asm"

