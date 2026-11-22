
	SECTION	code_sound_ay

	PUBLIC	_ay_wyz_start
	PUBLIC	_ay_wyz_start_fastcall

	EXTERN	asm_wyz_start


_ay_wyz_start:
	pop	bc
	pop	hl
	push	hl
	push	bc
_ay_wyz_start_fastcall:
	push	ix
	push	iy
	ld	a,l
	call	asm_wyz_start
	pop	iy
	pop	ix
	ret
