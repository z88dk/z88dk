


        SECTION   code_clib
        PUBLIC    getmaxx
        PUBLIC    _getmaxx
        EXTERN  __vz200_mode

        INCLUDE "graphics/grafix.inc"

.getmaxx
._getmaxx
        ld      a,(__vz200_mode)
        and     a
        ld      hl, +63
        ret     z
	ld	hl,127
        ret

