
    SECTION code_clib
    PUBLIC fgetc_cons
    PUBLIC _fgetc_cons
    EXTERN getk


    INCLUDE "target/radio86/def/monitor.def"

fgetc_cons:
_fgetc_cons:
    call    WAITKEY
    ld      l,a
    ld      h,0
    ret
    
