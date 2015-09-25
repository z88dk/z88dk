;
;	TIKI-100 specific routines
;	by Stefano Bodrato, Fall 2015
;
;	int get_psg(int reg);
;
;	Get a PSG register.
;
;
;	$Id: get_psg.asm,v 1.1 2015-09-25 14:56:01 stefano Exp $
;

	PUBLIC	get_psg
	
get_psg:

    LD	BC,$16
	OUT	(C),l

    LD	c,$17
	in	a,(C)

	ld	l,a
	ret
