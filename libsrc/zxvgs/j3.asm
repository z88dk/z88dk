;ZXVGS specific functions

;020121	(C) created by Yarek

	SECTION code_clib
	PUBLIC	j3
	PUBLIC	_j3

;int j3()
;returns joystick 3 state

.j3
._j3
	RST	8
	DEFB	$83
	LD	L,A
	LD	H,0		;does H have any matter?
	RET
