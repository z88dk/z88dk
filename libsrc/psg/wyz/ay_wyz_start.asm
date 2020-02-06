
	SECTION	code_psg

	PUBLIC	ay_wyz_start
	PUBLIC	_ay_wyz_start


	EXTERN	asm_wyz_start


ay_wyz_start:
_ay_wyz_start:
	ld	a,l
	jp	asm_wyz_start

	
