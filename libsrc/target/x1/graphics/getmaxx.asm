	INCLUDE	"graphics/grafix.inc"


        MODULE    x1_getmaxx
        SECTION   code_clib
        PUBLIC    getmaxx
        PUBLIC    _getmaxx
	EXTERN	  __x1_mode

.getmaxx
._getmaxx
	ld	a,(__x1_mode)
	ld	hl,319
	and	a
	ret	z
	ld	hl,639
	ret
