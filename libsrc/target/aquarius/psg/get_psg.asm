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
;	$Id: get_psg.asm,v 1.3 2016-06-10 21:13:57 dom Exp $
;


	SECTION code_clib
	PUBLIC	get_psg
	PUBLIC	_get_psg
	
get_psg:
_get_psg:

    LD	BC,$F7
	OUT	(C),l
	dec	c
	IN	a,(C)
	ld	l,a	; NOTE: A register has to keep the same value
	ret
