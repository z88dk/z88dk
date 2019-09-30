
	SECTION	code_clib

	PUBLIC	res_MODE2

.res_MODE2
	ld	a,h
	cp	128
	ret	nc

        defc    NEEDunplot = 1
        INCLUDE "graphics/pc6001/pixel_MODE2.inc"
