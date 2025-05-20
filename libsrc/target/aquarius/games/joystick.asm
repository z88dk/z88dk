        SECTION code_clib

	PUBLIC	joystick
	PUBLIC	_joystick

	EXTERN	joystick_inkey

	#include "target/aquarius/def/plus.inc"

        defc    RIGHT_BIT=0             ; 1
        defc    LEFT_BIT=1              ; 2
        defc    DOWN_BIT=2              ; 4
        defc    UP_BIT=3                ; 8
        defc    FIRE_BIT=4              ; 16

        ; exit : HL = 000FUDLR active high
_joystick:
joystick:
	ld	a, l
	cp	1
	jr	z, in_Joystick1
	cp	2
	jr	z, in_Joystick2

	; Try keyboard joystick
	sub	2
	jp	joystick_inkey

        ; Read controller 1
in_Joystick1:
        push    af

        ld      a, 7
        out     (IO_PSG1ADDR), a
        in      a, (IO_PSG1DATA)
        and     $3f
        out     (IO_PSG1DATA), a
        ld      a, 14
        out     (IO_PSG1ADDR), a
        in      a, (IO_PSG1DATA)
        jr      decodeJoy

        ; Read controller 2
in_Joystick2:
        push    af

        ld      a, 7
        out     (IO_PSG1ADDR), a
        in      a, (IO_PSG1DATA)
        and     $3f
        out     (IO_PSG1DATA), a
        ld      a, 15
        out     (IO_PSG1ADDR), a
        in      a, (IO_PSG1DATA)

decodeJoy:
        ld      hl, 0
        rrca
        jr      c, checkRight
        set     DOWN_BIT, l
checkRight:
        rrca
        jr      c, checkUp
        set     RIGHT_BIT, l
checkUp:
        rrca
        jr      c, checkLeft
        set     UP_BIT, l
checkLeft:
        rrca
        jr      c, checkJump
        set     LEFT_BIT, l
checkJump:
        and     %00000100
        jr      nz, done
        set     FIRE_BIT, l
done:
        pop     af
        ret
