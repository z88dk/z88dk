;
;	Sharp MZ-2500 graphics: the largest x (320 pixels across)
;
    SECTION code_clib
    PUBLIC  getmaxx
    PUBLIC  _getmaxx

getmaxx:
_getmaxx:
    ld      hl, 319
    ret
