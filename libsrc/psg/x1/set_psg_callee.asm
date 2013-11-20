;
;	Sharp specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg_callee.asm,v 1.1 2013-11-20 13:26:13 stefano Exp $
;

	XLIB	set_psg_callee

	XDEF ASMDISP_SET_PSG_CALLEE

	
set_psg_callee:

	pop	bc
	pop	de
	pop	hl

	push	hl
	push	de
	push	bc
	
.asmentry

    LD	BC,$1C00
	OUT	(C),l

	dec b
	OUT	(C),e
	ret

DEFC ASMDISP_SET_PSG_CALLEE = asmentry - set_psg_callee

