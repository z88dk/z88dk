;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg.asm,v 1.1 2013-11-18 10:59:06 stefano Exp $
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
	
psg_patch0:
    ld bc,$fffd
	out (c),l
psg_patch1:
	ld b,$bf
	out (c),e

	ret
