

	SECTION		code_fp_math32

	PUBLIC		l_f32_f2slong
	PUBLIC		l_f32_f2ulong
	PUBLIC		l_f32_f2sint
	PUBLIC		l_f32_f2uint

	EXTERN		l_long_neg
	EXTERN		l_f32_zero

; Convert floating point number to long
l_f32_f2sint:
l_f32_f2uint:
l_f32_f2slong:
l_f32_f2ulong:
        ld      a,d		;Holds sign + 7bits of exponent
        rl	e
        rla                     ;a = Exponent
        and     a
	jp	z,l_f32_zero	;Expontent was 0, return 0
        cp      $7e + 24
	jp	nc,l_f32_zero	;Number too large
	; e register is rotated by bit, restore the hidden bit and rotate back
	scf
	rr	e
loop:
	srl	e		;Fill with 0
	rr	h
	rr	l
	inc	a
	cp	$7e + 24
	jr	nz,loop
	rl	d		;Check sign bit
	ld	d,0
	jp	c,l_long_neg
	ret
