	INCLUDE	"graphics/grafix.inc"


        SECTION   code_clib
        PUBLIC    getmaxy
        PUBLIC    _getmaxy
	EXTERN	__gal_mode

.getmaxy
._getmaxy
        ld      a,(__gal_mode)
        and     a
        ld      hl, 47
        ret     z
        ld      hl, 207
        ret
