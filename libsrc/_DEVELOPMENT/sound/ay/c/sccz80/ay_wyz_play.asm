
	SECTION	code_sound_ay

	PUBLIC	ay_wyz_play

	EXTERN	asm_wyz_play

ay_wyz_play:
	push	ix
	push	iy
	call	asm_wyz_play
	pop	iy
	pop	ix
	ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC  _ay_wyz_play
defc _ay_wyz_play = ay_wyz_play
ENDIF
	
