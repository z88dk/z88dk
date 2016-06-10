;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg_callee.asm,v 1.4 2016-06-10 21:13:58 dom Exp $
;

	SECTION code_clib
	PUBLIC	set_psg_callee
	PUBLIC	_set_psg_callee

	EXTERN	__psg_select_and_read_port
	EXTERN	__psg_write_port
	
	PUBLIC ASMDISP_SET_PSG_CALLEE

	
set_psg_callee:

   pop hl
   pop de
   ex (sp),hl
	
.asmentry

	ld	bc,(__psg_select_and_read_port)
    	out	(c),l
	ld	bc,(__psg_write_port)
	out	(c),e
	ret

DEFC ASMDISP_SET_PSG_CALLEE = # asmentry - set_psg_callee
