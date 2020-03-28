;
;	ZX81 Spectrum specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg.asm,v 1.4 2016-06-26 20:32:08 dom Exp $
;

        SECTION code_clib
	PUBLIC	set_psg
	PUBLIC	_set_psg
	;PUBLIC	psg_patch0
	;PUBLIC	psg_patch1
	
set_psg:
_set_psg:

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
