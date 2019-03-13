	INCLUDE	"graphics/grafix.inc"

        MODULE    spc1000_getmaxy
        SECTION   code_clib
        PUBLIC    getmaxy
        PUBLIC    _getmaxy
	EXTERN	__spc1000_mode
        EXTERN  __tms9918_getmaxy

.getmaxy
._getmaxy
        ld      a,(__spc1000_mode)
	cp	10
	jp	nc,__tms9918_getmaxy
        and     a
        ld      hl, 47
        ret     z
        ld      hl, 191
        ret
