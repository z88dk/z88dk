;
;	Game device library for the PC6001
;

	SECTION code_clib
        PUBLIC    joystick
	PUBLIC	_joystick
	EXTERN	get_psg
	EXTERN	joystick_inkey


.joystick
._joystick
	;__FASTCALL__ : joystick no. in HL
	ld	a,14
	dec	l
	jr	z,got_port
	ld	a,l
	jp	joystick_inkey

got_port:
	ld	l,a
	call	get_psg		;Exits with a = value
	ld	hl,0
	rra
	jr	nc,not_fire
	set	4,l
not_fire:
	rra
	jr	nc,not_right
	set	0,l
not_right:
	rra
	jr	nc,not_left
	set	1,l
not_left:
	rra
	jr	nc,not_up
	set	3,l
not_up:
	rra
	ret	nc	;not down
	set	2,l
	ret
