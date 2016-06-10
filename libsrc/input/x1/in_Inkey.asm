;
;       Sharp X1 - Keyboard Input
; 
;       uint in_Inkey(void)
;       2013, Karl Von Dyson (X1s.org)
;

	SECTION code_clib
        PUBLIC in_Inkey
        PUBLIC _in_Inkey
        EXTERN _x1_keyboard_io

; exit : carry = no key registered (and HL=0)
;        else HL = ascii code of key pressed
; uses : AF, BC, HL

.in_Inkey
._in_Inkey
        ld hl, _x1_keyboard_io
        ld a, (hl)
        ld c, a
        inc hl
        ld a, (hl)
        and $40
        jp z, i_ikn
        ld hl, 0
        scf
        ret
.i_ikn  ld h, 0
        ld l, c
        ret
