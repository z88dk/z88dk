
	SECTION	code_clib

	PUBLIC	xor_MODE0

.xor_MODE0
        ld      a,l
        cp      16
        ret     nc
	ld	a,h
	cp	32
	ret	nc

        defc    NEEDxor = 1
        INCLUDE "gfx/gencon/pixel1.inc"
