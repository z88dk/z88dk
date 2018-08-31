	INCLUDE	"graphics/grafix.inc"


        SECTION   code_clib
        PUBLIC    getmaxy
        PUBLIC    _getmaxy
	EXTERN	__spc1000_mode

.getmaxy
._getmaxy
        ld      a,(__spc1000_mode)
        and     a
        ld      hl, 47
        ret     z
        ld      hl, 191
        ret
