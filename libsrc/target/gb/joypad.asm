


        MODULE  joypad

        PUBLIC  joypad
        PUBLIC  _joypad

	GLOBAL	asm_jpad

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

joypad:
_joypad:
	call	asm_jpad
	ld	e,a
	ld	l,a
	ld	h,0
	ret

