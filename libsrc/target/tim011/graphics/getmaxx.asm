	INCLUDE	"graphics/grafix.inc"


        MODULE    tim011_getmaxx
        SECTION   code_clib
        PUBLIC    getmaxx
        PUBLIC    _getmaxx
	EXTERN	  __gfx_fatpix

.getmaxx
._getmaxx
        ld      hl,255
        ld      a,(__gfx_fatpix)
        and     a
        ret     nz
        ld      hl,511
        ret
