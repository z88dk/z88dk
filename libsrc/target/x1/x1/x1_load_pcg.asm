
	SECTION	code_clib

	PUBLIC	x1_load_pcg
	PUBLIC	_x1_load_pcg

	EXTERN	asm_load_pcg


;void x1_load_pcg(int char, char data[8]) __z88dk_callee

x1_load_pcg:
_x1_load_pcg:
	pop	de	;ret
	pop	hl	;data
	pop	bc	;character
	push	de
	jp	asm_load_pcg
	

