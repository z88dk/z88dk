
	SECTION	code_clib

	PUBLIC	res_MODE0

.res_MODE0
        ld      a,l
        cp      16
        ret     nc
	ld	a,h
	cp	32
	ret	nc

        defc    NEEDunplot = 1
        INCLUDE "gfx/gencon/pixel1.inc"
