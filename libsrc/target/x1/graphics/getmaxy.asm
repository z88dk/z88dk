	INCLUDE	"graphics/grafix.inc"

        MODULE    x1_getmaxy
        SECTION   code_clib
        PUBLIC    getmaxy
        PUBLIC    _getmaxy
	EXTERN	__x1_mode

.getmaxy
._getmaxy
	ld	hl,199
	ret
