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


        SECTION code_clib

               PUBLIC    savescr
               PUBLIC    _savescr

                INCLUDE "saverst.def"

.savescr
._savescr
	push	ix
        ld      a,SR_SUS
        call_oz(os_sr)
        push    ix
        pop     de
	pop	ix
	ret	nc
        ld      hl,0
        ret
        
