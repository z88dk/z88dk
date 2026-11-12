;
;	Sharp MZ-800 graphics: the largest y (200 pixels down)
;
    SECTION code_clib
    PUBLIC  getmaxy
    PUBLIC  _getmaxy

getmaxy:
_getmaxy:
    ld      hl, 199
    ret
