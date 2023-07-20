
	SECTION	code_sound_ay

	PUBLIC	ay_wyz_play
	PUBLIC	ay_wyz_play_fastcall

	EXTERN	asm_wyz_play


ay_wyz_play:
    pop     bc
    pop     hl
    push    hl
    push    bc

ay_wyz_play_fastcall:
	push	ix
	push	iy
	call	asm_wyz_play
	pop     iy
	pop     ix
	ret

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC  _ay_wyz_play
defc _ay_wyz_play = ay_wyz_play

PUBLIC  _ay_wyz_play_fastcall
defc _ay_wyz_play_fastcall = ay_wyz_play_fastcall
ENDIF
	
