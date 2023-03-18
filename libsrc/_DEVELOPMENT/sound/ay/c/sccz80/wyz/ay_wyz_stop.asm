
	SECTION	code_sound_ay

	PUBLIC	ay_wyz_stop


	EXTERN	asm_wyz_stop

	defc ay_wyz_stop = asm_wyz_stop
	
; SDCC bridge for Classic
IF __CLASSIC
PUBLIC  _ay_wyz_stop
defc _ay_wyz_stop = ay_wyz_stop
ENDIF
