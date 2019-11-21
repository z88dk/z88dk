;

        SECTION code_clib
	PUBLIC	get_psg
	PUBLIC	_get_psg
	


get_psg:
_get_psg:
	ld	a,l
	out	($00),a

	IN	a,($02)
	ld	l,a	; NOTE: A register has to keep the same value
	ret
