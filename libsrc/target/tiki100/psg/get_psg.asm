;
;	TIKI-100 specific routines
;	by Stefano Bodrato, Fall 2015
;
;	int get_psg(int reg);
;
;	Get a PSG register.
;
;
;	$Id: get_psg.asm,v 1.2 2016-06-10 21:13:58 dom Exp $
;

        SECTION code_clib
	PUBLIC	get_psg
	PUBLIC	_get_psg
	
get_psg:
_get_psg:

    LD	BC,$16
	OUT	(C),l

    LD	c,$17
	in	a,(C)

	ld	l,a
	ret
