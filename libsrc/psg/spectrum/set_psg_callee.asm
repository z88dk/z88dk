;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, Fall 2013
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg_callee.asm,v 1.5 2017-01-02 23:57:08 aralbrec Exp $
;

	SECTION code_clib
	PUBLIC	set_psg_callee
	PUBLIC	_set_psg_callee

	EXTERN	__psg_select_and_read_port
	EXTERN	__psg_write_port
	
	PUBLIC ASMDISP_SET_PSG_CALLEE

	
set_psg_callee:
_set_psg_callee:

   pop hl
   pop de
   ex (sp),hl
	
.asmentry

	ld	bc,(__psg_select_and_read_port)
    	out	(c),l
	ld	bc,(__psg_write_port)
	out	(c),e
	; ZON-X
	ld a,l
	out ($ff),a
	ld a,e
	out ($7f),a
	; ZXM and "William Stuart"
	ld a,l
	out ($9f),a
	ld a,e
	out ($df),a
	ret

DEFC ASMDISP_SET_PSG_CALLEE = # asmentry - set_psg_callee
