


        MODULE  joypad

        PUBLIC  joypad
        PUBLIC  _joypad

	GLOBAL	__jpad

        SECTION code_driver

        INCLUDE "target/gb/def/gb_globals.def"

joypad:
_joypad:
	call	__jpad
	ld	e,a
	ld	l,a
	ld	h,0
	ret

