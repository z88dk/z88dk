;
;	Sharp specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int get_psg(int reg);
;
;	Get a PSG register
;
;
;	$Id: get_psg.asm,v 1.1 2013-11-20 13:26:13 stefano Exp $
;

	XLIB	get_psg
	
get_psg:

    LD	BC,$1C00
	OUT	(C),l
	dec	b
	IN	a,(C)
	ld	l,a	; NOTE: A register has to keep the same value
	ret
