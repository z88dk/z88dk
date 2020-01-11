;* * * * *  Small-C/Plus z88dk * * * * *
;  Version: 15597-fc7bb69c6-20191123
;
;	Reconstructed for z80 Module Assembler
;
;	Module compile time: Mon Jan  6 15:04:07 2020



	MODULE	joystick_type_c


	INCLUDE "z80_crt0.hdr"


	SECTION	rodata_compiler
._joystick_type
	defw	i_1+0
	defw	i_1+8
	defw	i_1+15
	defw	i_1+26
	defw	i_1+37
	defw	i_1+59
	SECTION	code_compiler
	SECTION	rodata_compiler
.i_1
	defm	"QAOP-MN"
	defb	0

	defm	"Cursor"
	defb	0

	defm	"Joystick 1"
	defb	0

	defm	"Joystick 2"
	defb	0

	defm	"Joystick 2 + Keypad 1"
	defb	0

	defm	"Joystick 2 + Keypad 2"
	defb	0


; --- Start of Static Variables ---

	SECTION	bss_compiler
	SECTION	code_compiler


; --- Start of Scope Defns ---

	GLOBAL	bksave
	GLOBAL	bkrestore
	GLOBAL	getsprite
	GLOBAL	putsprite
	GLOBAL	putsprite_callee
	GLOBAL	joystick
	GLOBAL	joystick_sc
	GLOBAL	kjoystick
	GLOBAL	_joystick_type


; --- End of Scope Defns ---


; --- End of Compilation ---
