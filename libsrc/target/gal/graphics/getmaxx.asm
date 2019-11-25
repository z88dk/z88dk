	INCLUDE	"graphics/grafix.inc"


        SECTION   code_clib
        PUBLIC    getmaxx
        PUBLIC    _getmaxx
	EXTERN	__gal_mode

.getmaxx
._getmaxx
	ld	a,(__gal_mode)
	and	a
	ld	hl, +63
	ret	z
	ld	hl,255
	ret
