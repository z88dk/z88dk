;
;	Game device library for the Pasopia7
;

	SECTION code_clib
        PUBLIC    joystick
	PUBLIC	_joystick
	EXTERN	get_psg

.joystick
._joystick
	;__FASTCALL__ : joystick no. in HL
	ld	bc,0x1a
	dec	l
	jr	z,got_port
	ld	bc,0x19
	dec	l
	jr	z,got_port
	ld	hl,0	
	ret

got_port:
	ld	a,1		;Select the joystick
	out	($1b),a
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
	jr	nc,not_fire1
	set	4,l
not_fire1:
	rra		;FIRE2
	ret	nc
	set	5,l
	ret

