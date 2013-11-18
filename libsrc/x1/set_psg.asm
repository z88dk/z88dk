;
;	Sharp specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg.asm,v 1.3 2013-11-18 16:13:11 stefano Exp $
;

	XLIB	set_psg
	
set_psg:

	pop	bc
	pop	de
	pop	hl

	push	hl
	push	de
	push	bc
	

    LD	BC,$1C00
	OUT	(C),l

	dec b
	OUT	(C),e
	ret

