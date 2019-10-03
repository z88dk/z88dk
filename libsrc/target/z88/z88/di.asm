;
;       Small C+ Runtime Library
;
;       Z88 Application functions
;
;       *** Z88 SPECIFIC FUNCTION - probably no equiv for your machine! ***
;
;       11/4/99
;
;       Disable interruptes
;       int di(void)


        SECTION code_clib

	PUBLIC    di
	PUBLIC    _di

	INCLUDE "interrpt.def"

.di
._di
        call    oz_di
        push    af
        pop     hl
        ret
        
