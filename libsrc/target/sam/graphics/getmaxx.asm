    MODULE  getmaxx
    SECTION code_clib
    PUBLIC  getmaxx
    PUBLIC  _getmaxx
    EXTERN  __zx_screenmode
    EXTERN  __gfx_fatpix

.getmaxx
._getmaxx
    ld      a,(__zx_screenmode)
    ld      hl,255
    cp      2
    ret     nz
    ld      a,(__gfx_fatpix)
    and     a
    ret     nz
    ld      hl,511
    ret 
