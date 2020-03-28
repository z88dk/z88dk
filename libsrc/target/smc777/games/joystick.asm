;
;	Game device library for the SMC-777
;

	SECTION code_clib
        PUBLIC    joystick
	PUBLIC	_joystick
	EXTERN	get_psg


.joystick
._joystick
	;__FASTCALL__ : joystick no. in HL
	ld	bc,$0151
	dec	l
	jr	z,got_port
	ld	bc,$0051
	dec	l
	jr	z,got_port
	ld	hl,0	
	ret

got_port:
	in	a,(c)
	ld	hl,0
	cpl
	rra		;UP
	rl	l
	rra		;DOWN
	rl	l	
	rra		;LEFT
	rl	l
	rra		;RIGHT
	rl	l
	rra		;FIRE1
	ret	nc
	set	4,l
	ret

