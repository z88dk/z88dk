;
;	Game device library for the PC6001
;

	SECTION code_clib
        PUBLIC    joystick
	PUBLIC	_joystick
	EXTERN	get_psg


.joystick
._joystick
	;__FASTCALL__ : joystick no. in HL
	ld	a,14
	dec	l
	jr	z,got_port
	inc	a	
	dec	l
	jr	z,got_port
	ld	hl,0	
	ret

got_port:
	ld	l,a
	call	get_psg		;Exits with a = value
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
	rra
	jr	nc,not_fire1
	set	4,l
not_fire1:
	rra
	ret	nc
	set	5,l
	ret

