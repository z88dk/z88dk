;
;       Small C+ Runtime Library
;
;       Z88 Application functions
;
;       *** Z88 SPECIFIC FUNCTION - probably no equiv for your machine! ***
;
;       11/4/99
;
;       Save User Screen
;
;       int restscr(int handle)
;
;       Returns 0 on failure, or 1 on success



               PUBLIC    restscr

                INCLUDE "saverst.def"

.restscr
        pop     bc
        pop     ix
        push    ix
        push    bc
        ld      a,SR_RUS
        call_oz(os_sr)
        ld      hl,0
        ret     c
        ld      hl,1
        ret
        