;
;	MSX specific routines
;	by Stefano Bodrato, December 2007
;
;	int msx_sound(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg.asm,v 1.1 2013-11-20 09:05:43 stefano Exp $
;

	XLIB	set_psg
	LIB		set_psg_callee
	
	XREF ASMDISP_SET_PSG_CALLEE
	

set_psg:

	pop	bc
	pop	de
	pop	hl

	push	hl
	push	de
	push	bc
	
	jp set_psg_callee + ASMDISP_SET_PSG_CALLEE
