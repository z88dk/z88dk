;
;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;   Based on the source of
;   Enterprise 64/128 C Library
;
;   getk() Read key status
;
;   Stefano Bodrato - 2011
;
;

    SECTION code_clib
    PUBLIC  getk
    PUBLIC  _getk
    EXTERN  fgetc_cons
    INCLUDE "target/tvc/def/tvc.def"


.getk
._getk
    rst     $30
    defb    KBD_STATUS
    ld      a,c
    and     a
    jp      nz,fgetc_cons

    ld  hl,0
    ret

