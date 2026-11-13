; Samsung SPC-1500 game devices
;
; int joystick(int game_device) __z88dk_fastcall;
;   1: the hardware joystick port (the AY's port A: register 14, read through
;   $1C00 and $1B00)
;   2-5: QAOP-space, 8246-05 (no keypad here: reads nothing), hjkl-sd, cursor
;   keys and space
;
; The port's bits are active low: 0 up, 1 down, 2 left, 3 right, 5 fire, 6 fire
; 2.  The result is as for the other targets:
; bit 0 right, 1 left, 2 down, 3 up, 4 fire 2, 5 fire.

    SECTION code_clib

    PUBLIC  joystick
    PUBLIC  _joystick

    EXTERN  joystick_inkey

joystick:
_joystick:
    ld      a, l
    cp      1
    jr      z, joy_port
    sub     1
    jp      joystick_inkey

joy_port:
    ld      bc, $1c00                   ; the AY's register 14, its port A (an input while the mixer's bit 6 is 0: the IPL and psg_init leave it so)
    ld      a, 14
    out     (c), a
    ld      b, $1b
    in      a, (c)
    cpl
    ld      b, a
    ld      hl, 0
    bit     3, b
    jr      z, no_right
    set     0, l
no_right:
    bit     2, b
    jr      z, no_left
    set     1, l
no_left:
    bit     1, b
    jr      z, no_down
    set     2, l
no_down:
    bit     0, b
    jr      z, no_up
    set     3, l
no_up:
    bit     5, b
    jr      z, no_fire
    set     5, l
no_fire:
    bit     6, b
    jr      z, joy_done
    set     4, l
joy_done:
    ret
