;ZXVGS specific functions

;020121	(C) created by Yarek

	PUBLIC	j0

;int j0()
;returns joystick 0 state

.j0
	RST	8
	DEFB	$80
	LD	L,A
	LD	H,0		;does H have any matter?
	RET
