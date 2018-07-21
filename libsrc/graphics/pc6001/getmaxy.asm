


        SECTION   code_clib
        PUBLIC    getmaxx
        PUBLIC    _getmaxx
        EXTERN  __pc6001_mode

        INCLUDE "graphics/grafix.inc"
	INCLUDE	"target/pc6001/def/pc6001.def"

.getmaxx
._getmaxx
        ld      a,(__pc6001_mode)
        and     a
        ld      hl, 47
        ret     z
        ld      hl,192
        ret

