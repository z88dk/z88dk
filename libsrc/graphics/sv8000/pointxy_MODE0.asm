
	SECTION	code_clib

	PUBLIC	pointxy_MODE0

.pointxy_MODE0
        ld      a,l
        cp      16
        ret     nc
	ld	a,h
	cp	32
	ret	nc

        defc    NEEDpoint = 1
        INCLUDE "graphics/generic_console/pixel1.asm"
