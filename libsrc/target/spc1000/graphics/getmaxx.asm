	INCLUDE	"graphics/grafix.inc"


        MODULE    spc1000_getmaxx
        SECTION   code_clib
        PUBLIC    getmaxx
        PUBLIC    _getmaxx
	EXTERN	  __spc1000_mode
        EXTERN    __tms9918_getmaxx

.getmaxx
._getmaxx
	ld	a,(__spc1000_mode)
	cp	10
	jp	nc,__tms9918_getmaxx
	and	a
	ld	hl, +63
	ret	z
	ld	hl,255
	dec	a
	ret	z
	ld	hl,127
	ret
