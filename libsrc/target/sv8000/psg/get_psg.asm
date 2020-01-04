;

        SECTION code_clib
	PUBLIC	get_psg
	PUBLIC	_get_psg
	


get_psg:
_get_psg:
	ld	a,l
	out	($c0),a

	; Not supported by the emulation yet...
	IN	a,($c0)
	ld	l,a	; NOTE: A register has to keep the same value
	ret
