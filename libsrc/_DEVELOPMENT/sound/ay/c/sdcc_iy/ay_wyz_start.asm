
	SECTION	code_psg

	PUBLIC	_ay_wyz_start

	EXTERN	asm_wyz_start


_ay_wyz_start:
	push	ix
	push	iy
	ld	a,l
	call	asm_wyz_start
	pop	iy
	pop	ix
	ret
