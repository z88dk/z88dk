; Sharp MZ-800 game devices
;
; int joystick(int game_device) __z88dk_fastcall;
;   1-2: the hardware ports ($F0 and $F1; $F0 is also the palette on writes)
;   3-6: QAOP-space, 8246-05 (no keypad here: reads nothing), hjkl-sd, cursor keys and space
;
; A port's bits are active low (the MSX style that MAME's MZ-800 has): 0 up, 1 down, 2 left, 3 right, 4 fire, 5 fire 2.  The result is as for the other targets:
; bit 0 right, 1 left, 2 down, 3 up, 4 fire 2, 5 fire.

    SECTION code_clib

    PUBLIC  joystick
    PUBLIC  _joystick

    EXTERN  joystick_inkey

joystick:
_joystick:
    ld      a, l
    cp      1
    jr      z, joy_port1
    cp      2
    jr      z, joy_port2
    sub     2
    jp      joystick_inkey

joy_port1:
    in      a, ($f0)
    jr      joy_read
joy_port2:
    in      a, ($f1)
joy_read:
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
    bit     4, b
    jr      z, no_fire
    set     5, l
no_fire:
    bit     5, b
    jr      z, joy_done
    set     4, l
joy_done:
    ret
