

        SECTION code_clib

        PUBLIC  joystick
        PUBLIC  _joystick
        EXTERN  joystick_inkey

joystick:
_joystick:
        ld      a,l
        cp      5
        jp      c,joystick_inkey
	ld	hl,0
	ret
