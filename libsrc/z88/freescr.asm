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
;       int freescr(int handle)
;
;       Returns 0 on failure, or 1 on success


        SECTION code_clib

               PUBLIC    freescr
               PUBLIC    _freescr

                INCLUDE "saverst.def"

.freescr
._freescr
        pop     bc
        pop     hl
        push    hl
        push    bc
	push	ix
	push	hl
	pop	ix
        ld      a,SR_FUS
        call_oz(os_sr)
	pop	ix
        ld      hl,0
        ret     c
	inc	hl
        ret
        
