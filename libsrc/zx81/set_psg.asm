;
;	ZX81 Spectrum specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg.asm,v 1.3 2015-01-23 07:07:31 stefano Exp $
;

	PUBLIC	set_psg
	;PUBLIC	psg_patch0
	;PUBLIC	psg_patch1
	
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
