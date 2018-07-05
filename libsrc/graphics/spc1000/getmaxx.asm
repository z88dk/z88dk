	INCLUDE	"graphics/grafix.inc"


        SECTION   code_clib
        PUBLIC    getmaxx
        PUBLIC    _getmaxx
	EXTERN	__spc1000_mode

.getmaxx
._getmaxx
	ld	a,(__spc1000_mode)
	and	a
	ld	hl, +63
	ret	z
	ld	hl,maxx-1
	ret
