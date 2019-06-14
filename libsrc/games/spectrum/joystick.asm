;
;	Game device library for the ZX Spectrum
;	Stefano Bodrato - 20/8/2001
;
;	$Id: joystick.asm,v 1.5 2016-04-23 21:06:32 dom Exp $
;

        SECTION   code_clib
        PUBLIC    joystick
        PUBLIC    _joystick

.joystick
._joystick
	;__FASTALL__ : joystick no. in HL
		
	ld	a,l

	cp	1	 ; Kempston Joystick
	jr	nz,j_no1
	in	a,(31)
	jp	j_done
.j_no1
	cp	2	 ; Sinclair 1
	jr	nz,j_no2
	ld	bc,61438  ; $EFFE
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
	jp	j_done
.j_no2
	cp	3	 ; Sinclair 2
	jr	nz,j_no3
	ld	bc,63486	; $F7FE
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
	cp	4	 ; Cursor KEYS
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
	ld	e,l	; save the "right" bit
	rr	l
	rr	l	; "up"
	rla
	rr	l	; "down"
	rla
	rl	h	; "left"
	rla
	rr	e	; "right"
	rla
	jr	j_done
.j_no4
	cp	5	 ; Fuller
	jr	nz,j_no5
	in	a,(127)
	ld	l,0
	rra
	rl	l
	rra
	rl	l
	rra
	rl	l
	rra
	rl	l
	rla
	and	16
	or	l
	jr	j_done
.j_no5
	cp	6	 ; QAOP-MN
	jr	nz,j_no6
	
;      #FEFE  SHIFT, Z, X, C, V            #EFFE  0, 9, 8, 7, 6
;      #FDFE  A, S, D, F, G                #DFFE  P, O, I, U, Y
;      #FBFE  Q, W, E, R, T                #BFFE  ENTER, L, K, J, H
;      #F7FE  1, 2, 3, 4, 5                #7FFE  SPACE, SYM SHFT, M, N, B

;00NMQAOP
	;ld	bc,$DFFE
	;in	a,(c)
	;cpl
	;and 3
	;jr j_done
	
	ld	bc,$7FFE
	in	a,(c)
	rra
	ld e,0
	rra		; N
	rl e
	rra		; M
	rl e
	ld	b,$FB
	in  a,(c)
	rra		; Q
	rl	e
	ld	b,$FD
	in  a,(c)
	rra		; A
	rl	e
	scf
	rl	e
	scf
	rl	e
	ld	b,$DF
	in  a,(c)
	or 252	; 11111100
	and e
	cpl
	and 63
	jr	j_done

.j_no6
	xor	a
	
.j_done
	ld	h,0
	ld	l,a
	ret
