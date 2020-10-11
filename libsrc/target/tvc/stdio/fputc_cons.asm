;
;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;   Based on the source of
;
;   Enterprise 64/128 C Library
;
;   Fputc_cons
;
;   Stefano Bodrato - 2011
;

    SECTION code_clib
    PUBLIC  fputc_cons_native
    INCLUDE "target/tvc/def/tvc.def"

;
; Entry:        stack contains a char
;
.fputc_cons_native
    ld      hl,2
    add     hl,sp
    ld      c,(hl)
    ld      a,c
    cp      10
    jr      nz,continue
    call    continue
    ld      c,13
continue:
    rst     $30
    defb    ED_CHOUT ; editor - character out
    ret

