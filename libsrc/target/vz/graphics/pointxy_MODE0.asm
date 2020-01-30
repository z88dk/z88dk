
	SECTION	code_clib

	PUBLIC	pointxy_MODE0

.pointxy_MODE0
        ld      a,l
        cp      32
        ret     nc
	ld	a,h
	cp	64
	ret	nc

        defc    NEEDpoint = 1
        INCLUDE "gfx/gencon/pixel.inc"
