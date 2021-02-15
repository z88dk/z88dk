
    SECTION code_clib
    PUBLIC getk
    PUBLIC _getk


    INCLUDE "target/radio86/def/monitor.def"

getk:
_getk:
    call    QUERYKEY
    ld      hl,0
    and     a
    ret     z
    call    WAITKEY
    ld      l,a
    ret
    
