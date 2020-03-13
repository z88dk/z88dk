
	SECTION	code_sound_ay

	PUBLIC	_ay_wyz_play
	PUBLIC	_ay_wyz_play_fastcall

	EXTERN	asm_wyz_play

_ay_wyz_play:
	pop	bc
	pop	hl
	push	hl
	push	bc

_ay_wyz_play_fastcall:
	push	ix
	push	iy
	call	asm_wyz_play
	pop	iy
	pop	ix
	ret
	
