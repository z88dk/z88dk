

    SECTION code_clib

    PUBLIC joystick
    PUBLIC _joystick
    EXTERN joystick_inkey
    EXTERN  getk

joystick:
_joystick:
    ld      a,l
    call    joystick_inkey
    ; Let OZ in
    push    hl
    call    getk
    pop     hl
	ret

