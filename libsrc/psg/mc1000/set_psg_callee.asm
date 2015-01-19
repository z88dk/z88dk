;
;	Sharp specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg_callee.asm,v 1.3 2015-01-19 01:33:04 pauloscustodio Exp $
;

	PUBLIC	set_psg_callee

	PUBLIC ASMDISP_SET_PSG_CALLEE

	
set_psg_callee:

   pop hl
   pop de
   ex (sp),hl
	
.asmentry

    LD	BC,$20
	OUT	(C),l

	ld	c,$60
	OUT	(C),e
	ret

DEFC ASMDISP_SET_PSG_CALLEE = # asmentry - set_psg_callee

