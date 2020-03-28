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


        SECTION code_clib

               PUBLIC    restscr
               PUBLIC    _restscr

                INCLUDE "saverst.def"

.restscr
._restscr
        pop     bc
        pop     hl
        push    hl
        push    bc
	push	ix
	push	hl
	pop	ix
        ld      a,SR_RUS
        call_oz(os_sr)
	pop	ix
        ld      hl,0
        ret     c
        ld      hl,1
        ret
        
