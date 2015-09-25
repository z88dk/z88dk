;
;	TIKI-100 specific routines
;	by Stefano Bodrato, Fall 2015
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg_callee.asm,v 1.1 2015-09-25 14:56:02 stefano Exp $
;

	PUBLIC	set_psg_callee

	PUBLIC ASMDISP_SET_PSG_CALLEE

	
set_psg_callee:

   pop hl
   pop de
   ex (sp),hl
	
.asmentry
	
    ld bc,$16
	out (c),l

	ld c,$17
	out (c),e

	ret

DEFC ASMDISP_SET_PSG_CALLEE = # asmentry - set_psg_callee
