    INCLUDE	"graphics/grafix.inc"


    MODULE  cpc_getmaxx
    SECTION code_clib
    PUBLIC  getmaxx
    PUBLIC  _getmaxx
    EXTERN	__cpc_mode
    EXTERN  __gfx_fatpix

.getmaxx
._getmaxx
    ld      hl,159
    ld      a,(__cpc_mode)
    and     a
    ret     z
    ld      hl,319
    cp      1
    ret     z
    ld      a,(__gfx_fatpix)
    and     a
    ret     nz
    ld      hl,639
    ret
