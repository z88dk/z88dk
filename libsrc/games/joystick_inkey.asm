; Keyboard joysticks based on inkey

	MODULE	INPUT_JOY_useinkey
	SECTION	code_clib


	PUBLIC	INPUT_JOY_useinkey

        EXTERN  joystick_sc
        EXTERN  keys_qaop
        EXTERN  keys_8246
        EXTERN  keys_vi
        EXTERN  keys_cursor

INPUT_JOY_useinkey:
        ld      hl,keys_qaop
        cp      1
        jp      z,joystick_sc
        ld      hl,keys_8246
        cp      2
        jp      z,joystick_sc
        ld      hl,keys_vi
        cp      3
        jp      z,joystick_sc
        ld      hl,keys_cursor
        cp      4
        jp      z,joystick_sc
        ld      hl,0
        ret
