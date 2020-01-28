
	SECTION	code_clib

	PUBLIC	joystick
	PUBLIC	_joystick
	EXTERN	joystick_inkey

	defc	joystick = joystick_inkey
	defc	_joystick = joystick_inkey
