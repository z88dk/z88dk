;
;	Timex 2068 specific routines
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
	PUBLIC	psg_patch0
;	PUBLIC	psg_patch1
	
	PUBLIC asm_set_psg

	
set_psg_callee:
_set_psg_callee:

   pop hl
   pop de
   ex (sp),hl
	
.asm_set_psg

	
psg_patch0:
    ld bc,$f5
	out (c),l
	inc c
	out (c),e

	ret

