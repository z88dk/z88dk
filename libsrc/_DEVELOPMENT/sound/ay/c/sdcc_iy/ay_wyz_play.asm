
	SECTION	code_psg

	PUBLIC	_ay_wyz_play

	EXTERN	asm_wyz_play

_ay_wyz_play:
	push	ix
	push	iy
	call	asm_wyz_play
	pop	iy
	pop	ix
	ret
	
