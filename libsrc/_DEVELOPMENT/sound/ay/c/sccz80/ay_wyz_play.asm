
	SECTION	code_psg

	PUBLIC	ay_wyz_play

	EXTERN	asm_wyz_play

ay_wyz_play:
	push	ix
	push	iy
	call	ay_wyz_play
	pop	iy
	pop	ix
	ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC  _ay_wyz_play
defc _ay_wyz_play = ay_wyz_play
ENDIF
	
