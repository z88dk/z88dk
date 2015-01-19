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
;       int savescr(void)
;
;       Returns 0 on failure, or handle on success



               PUBLIC    savescr

                INCLUDE "saverst.def"

.savescr
        ld      a,SR_SUS
        call_oz(os_sr)
        ld      hl,0
        ret     c
        push    ix
        pop     hl
        ret
        