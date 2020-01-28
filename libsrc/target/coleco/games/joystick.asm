
	SECTION	code_clib

	PUBLIC	joystick
	PUBLIC	_joystick
	EXTERN	coleco_joypad

	defc	joystick = coleco_joypad
	defc	_joystick = coleco_joypad
