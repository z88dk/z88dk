;
;	Timex 2068 specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg_callee.asm,v 1.2 2014-09-28 18:26:58 pauloscustodio Exp $
;

	XLIB	set_psg_callee
	XDEF	psg_patch0
	XDEF	psg_patch1
	
	XDEF ASMDISP_SET_PSG_CALLEE

	
set_psg_callee:

   pop hl
   pop de
   ex (sp),hl
	
.asmentry

	
psg_patch0:
    ld bc,$f5
	out (c),l
	inc c
	out (c),e

	ret

DEFC ASMDISP_SET_PSG_CALLEE = # asmentry - set_psg_callee
