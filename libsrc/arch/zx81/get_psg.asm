;
;	ZX81 specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int get_psg(int reg);
;
;	Get a PSG register, untested.
;	does not work on original ZonX, ZXpand-AY Sound Module is required
;
;
;	$Id: get_psg.asm,v 1.5 2017-01-03 02:07:44 aralbrec Exp $
;

	SECTION code_clib
	PUBLIC	get_psg
   PUBLIC   _get_psg
	
get_psg:
_get_psg:

    ;LD	BC,$cf
    ld bc,$df
	OUT	(C),l

    LD	c,$ef
	in	a,(C)

	ld	l,a
	ret
