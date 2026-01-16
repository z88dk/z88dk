
    SECTION code_clib
    PUBLIC  getk
    PUBLIC  _getk


    INCLUDE "target/radio86/def/radio86.h"

getk:
_getk:
    call    M_QUERYKEY
    ld      hl, 0
    and     a
    ret     z
    call    M_WAITKEY
    ld      l, a
    ret

