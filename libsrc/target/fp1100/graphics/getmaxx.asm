	INCLUDE	"graphics/grafix.inc"


        MODULE    fp1100_getmaxx
        SECTION   code_clib
        PUBLIC    getmaxx
        PUBLIC    _getmaxx
	EXTERN	  __fp1100_mode

.getmaxx
._getmaxx
	ld	a,(__fp1100_mode)
	ld	hl,319
	and	a
	ret	z
	ld	hl,639
	ret
