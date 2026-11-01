; Sharp MZ-2500 game devices
;
; int joystick(int game_device) __z88dk_fastcall;
;   1-2: hardware joystick ports
;   3-6: QAOP-MN, 8246-05, hjkl-sd, cursor key alternatives
;
; Port $EF selects a joystick on writes ($0F = port 1, $4F = port 2) and
; returns active-low inputs on reads: bit 0 up, bit 1 down, bit 2 left,
; bit 3 right, bit 4 fire, bit 5 fire 2.

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
    ld      a, $0f
    jr      joy_read
joy_port2:
    ld      a, $4f
joy_read:
    out     ($ef), a
    in      a, ($ef)
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
    set     4, l
no_fire:
    bit     5, b
    jr      z, joy_done
    set     5, l
joy_done:
    ret
