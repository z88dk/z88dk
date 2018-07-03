;
;       Plot pixel at (x,y) coordinate.



        SECTION code_clib
	PUBLIC	plotpixel
	EXTERN	__spc1000_mode
	defc	NEEDplot = 1

dotext:
	ld	a,l
	cp	32
	ret	nc
	INCLUDE	"graphics/generic_console/pixel.asm"

.plotpixel			
	ld	a,(__spc1000_mode)
	and	a
	jr	z,dotext
	INCLUDE "pixel.asm"



