
        MODULE    agon_getmaxy
        SECTION   code_clib
        PUBLIC    getmaxy
        PUBLIC    _getmaxy
        EXTERN    __agon_gfxh

.getmaxy
._getmaxy
        ld      hl,(__agon_gfxh)
        dec     hl
        ret

