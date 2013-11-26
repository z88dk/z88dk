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
;	$Id: get_psg.asm,v 1.2 2013-11-26 06:51:15 stefano Exp $
;

	XLIB	get_psg
	
get_psg:

    LD	BC,$cf
    ;ld bc,$df
	OUT	(C),l

    LD	c,$ef
	in	a,(C)

	ld	l,a
	ret
