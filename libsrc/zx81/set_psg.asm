;
;	ZX81 Spectrum specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg.asm,v 1.2 2013-11-18 14:00:22 stefano Exp $
;

	XLIB	set_psg
	XDEF	psg_patch0
	XDEF	psg_patch1
	
set_psg:

	pop	bc
	pop	de
	pop	hl

	push	hl
	push	de
	push	bc
	
    ;ld bc,$cf
    ld bc,$df
	out (c),l

	ld c,$0f
	out (c),e

	ret
