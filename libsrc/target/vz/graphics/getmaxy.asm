


        SECTION   code_clib
        PUBLIC    getmaxy
        PUBLIC    _getmaxy
        EXTERN  __vz200_mode

        INCLUDE "graphics/grafix.inc"

.getmaxy
._getmaxy
        ld      a,(__vz200_mode)
        and     a
        ld      hl,31
        ret     z
        ld      hl,63
        ret

