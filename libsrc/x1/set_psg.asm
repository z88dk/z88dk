;
;	Sharp specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg.asm,v 1.1 2013-11-15 11:23:48 stefano Exp $
;

	XLIB	set_psg
	
set_psg:

	pop	bc
	pop	de
	pop	hl

	push	hl
	push	de
	push	bc
	
	ld	a,l

    LD	BC,1C00H
	OUT	(C),A
	ld	a,e
	inc bc
	OUT	(C),A
	ret

