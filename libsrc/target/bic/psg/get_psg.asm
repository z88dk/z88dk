
        SECTION code_clib
	PUBLIC	get_psg	
	PUBLIC	_get_psg	

        INCLUDE "target/bic/bic.def"

get_psg:
_get_psg:
	ld	a,l

	out	(PSG_ADDR),a
	in	a,(PSG_DATAIN)	
	
	ld	h,0
	ld	l,a	; NOTE: A register has to keep the same value
	ret		;       internal code is using it !
