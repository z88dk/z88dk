
	SECTION	code_clib

	PUBLIC	joystick
	PUBLIC	_joystick
	EXTERN	joystick_inkey
	EXTERN	coleco_joypad

joystick:
_joystick:
	ld	a,l
	cp	5
	jp	c,joystick_inkey
	sub	4
	ld	l,a
	jp	coleco_joypad

