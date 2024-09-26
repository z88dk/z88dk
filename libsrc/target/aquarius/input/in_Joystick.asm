	; uint in_Joy1(void)
	; uint in_Joy2(void)

        SECTION code_clib
        PUBLIC  in_Joystick1
        PUBLIC  _in_Joystick1
        PUBLIC  in_Joystick2
        PUBLIC  _in_Joystick2

        defc    IO_PSG1DATA=$f6
        defc    IO_PSG1ADDR=$f7

        defc    UP_BIT=0                ; 1
        defc    DOWN_BIT=1              ; 2
        defc    LEFT_BIT=2              ; 4
        defc    RIGHT_BIT=3             ; 8
        defc    FIRE_BIT=7              ; 128

        ; Read controller 1
        ; exit : HL = F000RLDU active high
in_Joystick1:
_in_Joystick1:
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
        ; exit : HL = F000RLDU active high
in_Joystick2:
_in_Joystick2:
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
