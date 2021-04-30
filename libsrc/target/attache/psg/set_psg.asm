;
;	Otrona Attachè specific routines
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg.asm $
;

	SECTION code_clib
	PUBLIC	set_psg
	PUBLIC	_set_psg

	EXTERN asm_set_psg
	

set_psg:
_set_psg:

	pop	bc
	pop	de
	pop	hl

	push	hl
	push	de
	push	bc
	
	jp asm_set_psg

