


        SECTION   code_clib
        PUBLIC    getmaxy
        PUBLIC    _getmaxy
        EXTERN  __pc6001_mode

        INCLUDE "graphics/grafix.inc"
	INCLUDE	"target/pc6001/def/pc6001.def"

.getmaxy
._getmaxy
        ld      a,(__pc6001_mode)
        and     a
        ld      hl, 47
        ret     z
        ld      hl,191
        ret

