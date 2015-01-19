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
;	$Id: get_psg.asm,v 1.2 2015-01-19 01:33:04 pauloscustodio Exp $
;

	PUBLIC	get_psg
	
get_psg:

    LD	BC,$F7
	OUT	(C),l
	dec	c
	IN	a,(C)
	ld	l,a	; NOTE: A register has to keep the same value
	ret
