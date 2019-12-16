;
;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;   Based on the source of
;
;   Enterprise 64/128 C Library
;
;   Fgetc_cons
;
;   Stefano Bodrato - 2011
;

    SECTION code_clib
    PUBLIC  fgetc_cons
    INCLUDE "target/tvc/def/tvc.def"

;
; Entry:        none
;
.fgetc_cons
._fgetc_cons
    rst     $30
    defb    KBD_CHIN ; keyboard - character in
    ld l,c
    ld h,0
    ret

