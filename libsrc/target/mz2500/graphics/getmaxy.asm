;
;	Sharp MZ-2500 graphics: the largest y (200 lines)
;
    SECTION code_clib
    PUBLIC  getmaxy
    PUBLIC  _getmaxy

getmaxy:
_getmaxy:
    ld      hl, 199
    ret
