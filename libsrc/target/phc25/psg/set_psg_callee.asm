;
;	Sanyo PHC-25 Optional PSG-01 sound extension
;	by Stefano Bodrato, 2022
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
	
.asm_set_psg
	
    ld bc,$c1
	out	(c),l
	dec bc
	out	(c),e
	ret
