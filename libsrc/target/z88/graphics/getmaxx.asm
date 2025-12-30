    SECTION code_graphics
    PUBLIC  getmaxx
    PUBLIC  _getmaxx
    EXTERN  __z88_gfxmode

getmaxx:
_getmaxx:
    ld      hl,255
    ld      a,(__z88_gfxmode)
    and     a
    ret     z
    ld      hl,511
    ret
