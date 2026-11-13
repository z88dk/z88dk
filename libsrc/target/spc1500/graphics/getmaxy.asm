;
;	Samsung SPC-1500 graphics: the largest x (320 pixels across)
;
    SECTION code_clib
    PUBLIC  getmaxy
    PUBLIC  _getmaxy

getmaxy:
_getmaxy:
    ld      hl, 199
    ret
