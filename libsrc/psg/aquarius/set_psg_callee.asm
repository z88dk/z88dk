;
;	Mattel Aquarius routines
;	by Stefano Bodrato, Fall 2013
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg_callee.asm,v 1.1 2013-11-20 22:05:07 stefano Exp $
;

	XLIB	set_psg_callee

	XDEF ASMDISP_SET_PSG_CALLEE

	
set_psg_callee:

   pop hl
   pop de
   ex (sp),hl
	
.asmentry

    LD	BC,$F7
	OUT	(C),l

	dec c
	OUT	(C),e
	ret

DEFC ASMDISP_SET_PSG_CALLEE = asmentry - set_psg_callee

