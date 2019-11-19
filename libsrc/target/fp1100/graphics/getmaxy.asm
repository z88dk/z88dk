	INCLUDE	"graphics/grafix.inc"

        MODULE    fp1100_getmaxy
        SECTION   code_clib
        PUBLIC    getmaxy
        PUBLIC    _getmaxy

.getmaxy
._getmaxy
	ld	hl,199
	ret
