	INCLUDE	"graphics/grafix.inc"


        MODULE    agon_getmaxx
        SECTION   code_clib
        PUBLIC    getmaxx
        PUBLIC    _getmaxx
	EXTERN	  __agon_gfxw

.getmaxx
._getmaxx
	ld	hl,(__agon_gfxw)
        dec     hl
        ret
