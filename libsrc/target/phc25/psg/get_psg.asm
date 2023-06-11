;
;	Amstrad PCW specific routines (DKTronics sound generator)
;	by Stefano Bodrato, 2021
;
;	int get_psg(int reg);
;
;	Get a PSG register, untested.
;
;
;	$Id: get_psg.asm $
;

        SECTION code_clib
	PUBLIC	get_psg
	PUBLIC	_get_psg
	
get_psg:
_get_psg:

    LD	BC,$C1
	out	(c),l
	in	a,(c)

	ld	l,a
	ret
