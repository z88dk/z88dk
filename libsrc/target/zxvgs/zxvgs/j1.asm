;ZXVGS specific functions

;020121	(C) created by Yarek

	SECTION code_clib
	PUBLIC	j1
	PUBLIC	_j1

;int j1()
;returns joystick 1 state

.j1
._j1
	RST	8
	DEFB	$81
	LD	L,A
	LD	H,0		;does H have any matter?
	RET
