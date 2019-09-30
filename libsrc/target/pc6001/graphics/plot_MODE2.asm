
	SECTION	code_clib

	PUBLIC	plot_MODE2

.plot_MODE2
	ld	a,h
	cp	128
	ret	nc

        defc    NEEDplot = 1
        INCLUDE "target/pc6001/graphics/pixel_MODE2.inc"
