; Game device library for the Commodore 128
; Stefano Bodrato, Feb. 2017
;
;

    SECTION code_clib
    PUBLIC    joystick
    PUBLIC    _joystick
	
	EXTERN	savecia
	EXTERN	restorecia
	EXTERN	getk

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
    cp    3
    jr    z,keyb
    cp    2
    ld    a,255
    jr    nz,j_done
	
;  outp(cia1+ciaDataDirA,0x00);
;  ciaJoy2 = inp(cia1+ciaDataA) & ciaNone;

        dec     bc              ; cia1+ciaDataDirA
        xor	a
        out     (c),a

        ld      bc,$DC00        ;cia1+ciaDataA
        in	a,(c)

		jr jpp
	

.j_p1
    ; Player 1's joystick.
;  outp(cia1+ciaDataDirB,0x00);
;  ciaJoy1 = inp(cia1+ciaDataB) & ciaNone;

		; bc = cia1+ciaDataDirB
        xor	a
        out     (c),a

        ld      bc,$DC01        ;cia1+ciaDataB
        in	a,(c)


.jpp
		cpl
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

; Keyboard scan
.keyb
	ld	l,0
	ld      bc,$dc00
    ld      a,@01111111
	out     (c),a
	inc     bc
	in      a,(c)
	dec     bc
	and		@01000000	; Q
	jr		nz,no_up
	set	3,l
.no_up
    ld      a,@11111101
	out     (c),a
	inc     bc
	in      a,(c)
	dec     bc
	and		@00000100	; A
	jr	nz,no_down
	set	2,l
.no_down

    ld      a,@11011111
	out     (c),a
	inc     bc
	in      a,(c)
	dec     bc
	and		@00000010	; P
	jr	nz,no_right
	set	0,l
.no_right

    ld      a,@11101111
	out     (c),a
	inc     bc
	in      a,(c)
	ld	e,a
	and		@01000000	; O
	jr	nz,no_left
	set	1,l
.no_left

	ld	a,@00010000	; M
	and e
	xor @00010000
	or l
	jr j_done
	

