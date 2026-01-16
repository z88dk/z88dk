    SECTION code_graphics
    PUBLIC  getmaxy
    PUBLIC  _getmaxy
    EXTERN  __z88_gfxmode
    EXTERN  CLIB_ZX_SCREEN_HEIGHT

getmaxy:
_getmaxy:
    ld      hl,63
    ld      a,(__z88_gfxmode)
    cp      2
    ret     nz
    ld      hl,+(CLIB_ZX_SCREEN_HEIGHT * 8) - 1
    ret
