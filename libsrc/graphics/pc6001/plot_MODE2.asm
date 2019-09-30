
	SECTION	code_clib

	PUBLIC	plot_MODE2

.plot_MODE2
	ld	a,h
	cp	128
	ret	nc

        defc    NEEDplot = 1
        INCLUDE "graphics/pc6001/pixel_MODE2.inc"
