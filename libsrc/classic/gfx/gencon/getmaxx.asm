
    SECTION code_clib
    PUBLIC  getmaxx

    EXTERN  __console_w

    PUBLIC  _getmaxx
    defc    _getmaxx=getmaxx

    INCLUDE "classic/gfx/grafix.inc"

getmaxx:
    ld      a, (__console_w)
IF  !_GFX_GENCON_PIXEL3
    add     a
ENDIF
    dec     a
    ld      l, a
    ld      h, 0
    ret
