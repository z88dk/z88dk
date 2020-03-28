
	SECTION	code_clib

	PUBLIC	joystick
	PUBLIC	_joystick
	EXTERN	joystick_inkey

joystick:
_joystick:
	ld	a,l
	jp	joystick_inkey

