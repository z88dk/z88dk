	INCLUDE	"graphics/grafix.inc"


        MODULE    multi8_getmaxx
        SECTION   code_clib
        PUBLIC    getmaxx
        PUBLIC    _getmaxx
        EXTERN    __gfx_fatpix

.getmaxx
._getmaxx
        ld      hl,319
        ld      a,(__gfx_fatpix)
        and     a
        ret     nz
        ld      hl,639
	ret
