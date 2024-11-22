    SECTION code_clib
    PUBLIC  getk
    PUBLIC  _getk
    PUBLIC  fgetc_cons
    PUBLIC  _fgetc_cons

    INCLUDE "target/alphatp2/def/alphatp2.def"

getk:
_getk:
    call    CSTS
    ld      hl,0
    ret     z
fgetc_cons:
_fgetc_cons:
    call    TASTE
    ld      l,a
    ld      h,0
    ret

