
	SECTION	code_clib

	PUBLIC	pointxy_MODE2

.pointxy_MODE2
	ld	a,h
	cp	128
	ret	nc

        defc    NEEDpoint = 1
        INCLUDE "graphics/spc1000/pixel_MODE2.inc"
