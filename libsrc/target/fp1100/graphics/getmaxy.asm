	INCLUDE	"graphics/grafix.inc"

    MODULE    fp1100_getmaxy
    SECTION   code_clib
    PUBLIC    getmaxy
    PUBLIC    _getmaxy
    EXTERN    __fp1100_mode
    EXTERN    __console_h

.getmaxy
._getmaxy
    ld      hl,199
    ld      a,(__fp1100_mode)
    bit     1,a
    ret     z
    ld      a,(__console_h)
    add     a
    dec     a
    ld      l,a
    ld      h,0
    ret