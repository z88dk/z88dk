;
;	Generic game device library
;	Stefano Bodrato - 20/8/2001
;
;	$Id: joystick.asm,v 1.5 2016-04-23 21:06:32 dom Exp $
;

    SECTION code_clib
    PUBLIC  joystick
    PUBLIC  _joystick
    EXTERN  joystick_inkey
    EXTERN  getk

    INCLUDE "games/games.inc"

joystick:
_joystick:
    ;__FASTALL__ : joystick no. in HL
    ld      a, l

    cp      1                           ; Stick emulation 1 (qaop-mn)
    jr      nz, j_no1
    INCLUDE "games/joystick_qaop.as1"
j_no1:
    cp      2                           ; Stick emulation 2 (8246-05)
    jr      nz, j_no2
    INCLUDE "games/joystick_cursors.as1"
j_no2:
    ld      hl, 0
    ret

