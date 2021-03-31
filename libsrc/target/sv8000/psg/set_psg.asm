;
;	int set_psg(int reg, int val);
;

        SECTION code_clib
	PUBLIC	set_psg
	PUBLIC	_set_psg

	EXTERN asm_set_psg
	

set_psg:
_set_psg:

	pop	bc
	pop	de
	pop	hl

	push	hl
	push	de
	push	bc
	
	jp asm_set_psg

