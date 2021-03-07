    SECTION code_clib

    PUBLIC  joystick
    PUBLIC  _joystick

    EXTERN  _pause_flag


joystick:
_joystick:
	ld	a,l
	ld	hl,0
	cp	1
	jp	z,read_joypad1
	cp	2
	ret	nz
        in      a, ($dc)        ; Reads UP and DOWN
        cpl                     ; Inverts all bits
        rla
        rla
        rla                     ; Puts them into the 2 lower bits
        and     $03             ; Masks them
        ld      l, a
        in      a, ($dd)        ; Reads the remaining bits
        cpl                     ; Inverts all bits
        add     a
        add     a               ; Shifts them to the correct position
        or      l               ; Groups them with the first two

	; Now we need to normalise to z88dk conventions
normalise:
	ld	e,a
	and	15
	ld	l,a
	ld	bc,table
	add	hl,bc
	ld	l,(hl)		;That's directions sorted
	ld	a,e
	and	@00110000
	or	l
	ld	l,a
	; Pause comes in via NMI, the crt0 toggles the pause_flag variable
        ld      a,(_pause_flag)	;Handled by the crt0
        rrca	;bit 0 -> bit 7
        rrca	;bit 7 -> bit 6	- into FIRE3
        or      l
        ld      l,a
	ld	h,0
	ret


read_joypad1:
	in	a,($dc)
	cpl
	jr	normalise


	
	SECTION	rodata_clib
; Map between SMS directions and z88dk directions
table:
	defb	@0000		;Nothing pressed
	defb	@1000		;UP
	defb	@0100		;DOWN
	defb	@1100		;UP+DOWN
	defb	@0010		;LEFT
	defb	@1010		;UP + LEFT
	defb	@0110		;DOWN + LEFT
	defb	@1110		;UP + DOWN + LEFT
	defb	@0001		;RIGHT
	defb	@1001		;UP + RIGHT
	defb	@0101		;DOWN + RIGHT
	defb	@1101		;UP + DOWN + RIGHT
	defb	@0011		;LEFT + RIGHT
	defb	@1011		;UP + LEFT + RIGHT
	defb	@0111		;DOWN + LEFT + RIGHT
	defb	@1111		;UP + DOWN + LEFT + RIGHT

