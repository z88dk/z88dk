;
;	Amstrad PCW specific routines (DKTronics sound generator)
;	by Stefano Bodrato, 2021
;
;	int get_psg(int reg);
;
;	Get a PSG register, untested.
;	does not work on original ZonX, ZXpand-AY Sound Module is required
;
;
;	$Id: get_psg.asm $
;

        SECTION code_clib
	PUBLIC	get_psg
	PUBLIC	_get_psg
	
get_psg:
_get_psg:

    LD	BC,$aa
	OUT	(C),l

    LD	c,$a9
	in	a,(C)

	ld	l,a
	ret
