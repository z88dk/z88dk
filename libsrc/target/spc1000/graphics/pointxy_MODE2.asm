
	SECTION	code_clib

	PUBLIC	pointxy_MODE2

.pointxy_MODE2
	ld	a,h
	cp	128
	ret	nc

        defc    NEEDpoint = 1
        INCLUDE "target/spc1000/graphics/pixel_MODE2.inc"
