


        SECTION   code_clib
        PUBLIC    getmaxx
        PUBLIC    _getmaxx
        EXTERN  __sv8000_mode

        INCLUDE "graphics/grafix.inc"
	INCLUDE	"target/sv8000/def/sv8000.def"

.getmaxx
._getmaxx
        ld      a,(__sv8000_mode)
        and     a
        ld      hl, +31
        ret     z
        ld      hl,255
	ret

