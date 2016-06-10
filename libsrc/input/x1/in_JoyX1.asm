;
;       Sharp X1 - Joystick
; 
;       uint in_JoyX1(char num)
;       2013, Karl Von Dyson (X1s.org)
;

	SECTION code_clib
        PUBLIC in_JoyX1
        PUBLIC _in_JoyX1

; in   : (HL) = gamepad/joystick number
; exit : HL = FF00RLDU
; uses : AF, BC, HL

.in_JoyX1
._in_JoyX1
        ld hl,2
        add hl,sp
        ld a,(hl)
        ld bc, $1C00
        out (c), a
        dec b
        in a, (c)
        cpl
        ld b, a
	and $CF
        ld c, a
	ld a, b
	and $30
        sla a
        sla a
        or c
        ld l, a
        ld h, 0
        ret
