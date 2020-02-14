;
;
;	int get_psg(int reg);
;
;	Get a PSG register.
;
;

        SECTION code_clib
	PUBLIC	get_psg
	PUBLIC	_get_psg
	
get_psg:
_get_psg:
	ld	a,l
	out	($15),a
	in	a,($14)
	ld	l,a
	ret
