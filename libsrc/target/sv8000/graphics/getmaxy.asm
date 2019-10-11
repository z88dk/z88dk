


        SECTION   code_clib
        PUBLIC    getmaxy
        PUBLIC    _getmaxy
        EXTERN  __sv8000_mode

        INCLUDE "graphics/grafix.inc"
	INCLUDE	"target/sv8000/def/sv8000.def"

.getmaxy
._getmaxy
        ld      a,(__sv8000_mode)
        and     a
        ld      hl, 15
        ret     z
        ld      hl,95
        ret

