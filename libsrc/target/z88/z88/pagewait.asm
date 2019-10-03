;
;       Small C+ Runtime Library
;
;       Z88 Application functions
;
;       *** Z88 SPECIFIC FUNCTION - probably no equiv for your machine! ***
;
;       11/4/99
;
;       Page wait routine
;
;       int pagewait(void)
;
;       Returns with key pressed


        SECTION code_clib

               PUBLIC    pagewait
               PUBLIC    _pagewait

                INCLUDE "saverst.def"

.pagewait
._pagewait
        ld      a,SR_PWT
        call_oz(os_sr)
        ld      l,a
        ld      h,0
        ret     nc
        dec     a               ; rc.esc
        ld      hl,-1
        ret     z
        inc     hl
        ret
        
