;ZXVGS specific functions

;020121	(C) created by Yarek

	SECTION code_clib
	PUBLIC	j2
	PUBLIC	_j2

;int j2()
;returns joystick 2 state

.j2
._j2
	RST	8
	DEFB	$82
	LD	L,A
	LD	H,0		;does H have any matter?
	RET
