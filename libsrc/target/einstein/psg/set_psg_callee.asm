;
;	Einstein specific routines
;	by Stefano Bodrato, Fall 2017
;
;	int set_psg(int reg, int val);
;
;	Play a sound by PSG
;
;
;	$Id: set_psg_callee.asm $
;

        SECTION code_clib
	PUBLIC	set_psg_callee
	PUBLIC	_set_psg_callee

	PUBLIC asm_set_psg

	
set_psg_callee:
_set_psg_callee:


   pop hl
   pop de
   ex (sp),hl
	
asm_set_psg:
    ld	a,l
	OUT	(2),a

	ld a,e
	OUT	(3),A
	ret


