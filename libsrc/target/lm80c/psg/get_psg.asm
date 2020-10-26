;

        SECTION code_clib
	PUBLIC	get_psg
	PUBLIC	_get_psg
        EXTERN  PSG_AY_REG	
        EXTERN  PSG_AY_DATA


get_psg:
_get_psg:
	ld	a,l
	out	(PSG_AY_REG),a

	in	a,(PSG_AY_DATA)
	ld	l,a	; NOTE: A register has to keep the same value
	ret
