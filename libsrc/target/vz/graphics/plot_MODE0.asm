
	SECTION	code_clib

	PUBLIC	plot_MODE0

.plot_MODE0
        ld      a,l
        cp      32
        ret     nc
	ld	a,h
	cp	64
	ret	nc

        defc    NEEDplot = 1
        INCLUDE "gfx/gencon/pixel.inc"
