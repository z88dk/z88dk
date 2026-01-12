    SECTION code_graphics
    PUBLIC  getmaxx
    PUBLIC  _getmaxx
    EXTERN  __z88_gfxmode

getmaxx:
_getmaxx:
    ld      hl,511
    ld      a,(__z88_gfxmode)
    cp      1
    ret     z
    ld      hl,255
    ret
