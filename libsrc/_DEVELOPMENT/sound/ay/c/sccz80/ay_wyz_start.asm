
	SECTION	code_sound_ay

	PUBLIC	ay_wyz_start

	EXTERN	asm_wyz_start


ay_wyz_start:
	push	ix
	push	iy
	ld	a,l
	call	asm_wyz_start
	pop	iy
	pop	ix
	ret

	
; SDCC bridge for Classic
IF __CLASSIC
PUBLIC  _ay_wyz_start
defc _ay_wyz_start = ay_wyz_start
ENDIF
