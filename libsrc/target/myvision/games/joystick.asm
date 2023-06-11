
	MODULE	joystick
	SECTION	code_clib
	EXTERN	joystick_sc

	PUBLIC	joystick
	PUBLIC	_joystick

joystick:
_joystick:
	ld	a,l
        ld      hl,keys_cursors
        cp      1
        jp      z,joystick_sc
        ld      hl,keys_1234
        cp      2
        jp      z,joystick_sc
	ld	hl,0
        ret

	SECTION	rodata_clib

keys_cursors:
	defw	$10df, $08ef, $107f, $08bf, $10ef, $20df, $20ef, $20bf

keys_1234:
	defw	$807f, $80df, $80ef, $80bf, $407f, $40df, $40ef, $40bf
