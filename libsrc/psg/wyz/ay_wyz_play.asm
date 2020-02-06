
	SECTION	code_psg

	PUBLIC	ay_wyz_play
	PUBLIC	_ay_wyz_play


	EXTERN	asm_wyz_play

	defc ay_wyz_play = asm_wyz_play
	defc _ay_wyz_play = ay_wyz_play
	
