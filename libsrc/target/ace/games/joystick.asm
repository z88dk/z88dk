;
;	Game device library for the Jupiter ACE
;	Stefano Bodrato - 2018
;
;	$Id: joystick.asm $
;

        SECTION   code_clib
        PUBLIC    joystick
        PUBLIC    _joystick

.joystick
._joystick
	;__FASTALL__ : joystick no. in HL
		
	ld	a,l

	cp	1	 ; Sinclair 1
	jr	nz,j_no2
	ld	bc,61438
	in	a,(c)
	xor	@00011111
	ld	l,a
	xor	a
	rr	l
	rla
	rr	l
	rla
	rr	l
	rla
	rr	l
	rr	l
	rla
	rl	l
	rla
	jr	j_done
.j_no2
	cp	2	 ; Sinclair 2
	jr	nz,j_no3
	ld	bc,63486
	in	a,(c)
	xor	@00011111
	ld	l,a
	and	@00011100
	ld	h,a
	xor	a
	rr	l
	rla
	rr	l
	rla
	or	h
	jr	j_done
.j_no3
	cp	3	 ; Cursor KEYS
	jr	nz,j_no4
	ld	bc,$F7FE
	in	a,(c)
	rla
	rla
	rla
	xor	128
	ld	h,a
	ld	b,$EF
	in	a,(c)
	xor	@00011111
	ld	l,a
	rra
	and	1	; "fire2"
	rr	l	; "fire1"
	rla
	rr	l
	ld	e,l	; 8: save the "right" bit
	rr	l
        ld      d,l
        rr      l
	rr	l	; 7: "down"
	rla
	rr	d	; 6: "up"
	rla
	rl	h	; 5: "left"
	rla
	rr	e	; "right"
	rla
	jr	j_done
.j_no4
	xor	a
.j_done
	ld	h,0
	ld	l,a
	ret
