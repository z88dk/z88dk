;
;	Mattel Aquarius routines
;	by Stefano Bodrato, Fall 2013
;
;	int get_psg(int reg);
;
;	Get a PSG register
;
;	NOTE: I'm guessing here, I don't know
;         if the Aquarius permits to read back the psg registers !!
;
;
;	$Id: get_psg.asm,v 1.1 2013-11-20 22:05:07 stefano Exp $
;

	XLIB	get_psg
	
get_psg:

    LD	BC,$F7
	OUT	(C),l
	dec	c
	IN	a,(C)
	ld	l,a	; NOTE: A register has to keep the same value
	ret
