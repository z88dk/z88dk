; Game device library for the Commodore 128
; Stefano Bodrato, Feb. 2017
;
;

    SECTION code_clib
    PUBLIC    joystick
    PUBLIC    _joystick
	
	EXTERN	savecia
	EXTERN	restorecia

.joystick
._joystick

    ; __FASTCALL__ : joystick no. in HL.
    ; 1 = Player 1's joystick.
    ; 2 = Player 2's joystick.

	push hl
	;  SaveReg = inp(cia1+ciaDataDirA);
	call savecia
	pop hl

    ld    a,l
    cp    1
    jr    z,j_p1
    cp    2
	ld    a,0
    jr    nz,j_done
	
;  outp(cia1+ciaDataDirA,0x00);
;  ciaJoy2 = inp(cia1+ciaDataA) & ciaNone;

        push	bc
        dec     bc              ;cia1+ciaDataDirA
        xor	a
        out     (c),a

        ld      bc,$DC00        ;cia1+ciaDataA
        in	a,(c)

		jr jpp
	

.j_p1
    ; Player 1's joystick.
;  outp(cia1+ciaDataDirB,0x00);
;  ciaJoy1 = inp(cia1+ciaDataB) & ciaNone;

        pop	bc		;cia1+ciaDataDirB
        xor	a
        out     (c),a

        ld      bc,$DC01        ;cia1+ciaDataB
        in	a,(c)


.jpp
		ld h,a
		ld l,0
		rra		; R
		rl l
		rra		; L
		rl l
		rra		; D
		rl l
		rra		; U
		rl l
		ld a,h
		and $10	; Fire
		or	l

; ---FUDLR  Stick bit pattern (nc, nc, nc, fire, up, down, left, right)


.j_done
    ld    l,a
    ld    h,0
	
	push hl
	call restorecia
	pop hl
	
    ret
