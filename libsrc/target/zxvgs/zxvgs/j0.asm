;ZXVGS specific functions

;020121	(C) created by Yarek

	SECTION code_clib
	PUBLIC	j0
	PUBLIC	_j0

;int j0()
;returns joystick 0 state

.j0
._j0
	RST	8
	DEFB	$80
	LD	L,A
	LD	H,0		;does H have any matter?
	RET
