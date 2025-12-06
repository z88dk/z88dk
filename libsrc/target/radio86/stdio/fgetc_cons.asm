
    SECTION code_clib
    PUBLIC  fgetc_cons
    PUBLIC  _fgetc_cons
    EXTERN  getk


    INCLUDE "target/radio86/def/radio86.h"

fgetc_cons:
_fgetc_cons:
    call    M_WAITKEY
    ld      l, a
    ld      h, 0
    ret

