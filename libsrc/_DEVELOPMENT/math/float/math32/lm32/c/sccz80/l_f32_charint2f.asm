        MODULE  l_f32_uchar2f
        SECTION code_fp_math32

        PUBLIC  l_f32_uchar2f
        PUBLIC  l_f32_uint2f
        PUBLIC  l_f32_schar2f
        PUBLIC  l_f32_sint2f

	EXTERN	l_f32_zero
        EXTERN  l_neg_hl


; Convert (un)signed char/int in hl to floating point value in dehl
l_f32_uchar2f:
l_f32_uint2f:
        ld      d,0
        jr      not_negative
l_f32_schar2f:
l_f32_sint2f:
        ld      d,0
        bit     7,h
        jr      z,not_negative
        call    l_neg_hl
	ld	d,128
not_negative:
	ld	b,$7f + 15
	ld	a,h
	or	l
	jp	z,l_f32_zero
loop:
	bit	7,h
	jr	nz,rotate_done
	sla	l
	rl	h
	dec	b
	jr	loop
rotate_done:
	; So we have b = exponent, d has sign bit, hl = value
	rl	h	;Discard implicit
	srl	b	;Shift exponent
	rr	h	;Lowest bit of exponent now at top of mantissa
	ld	e,h	;MSB of mantissa
	ld	a,d	;Lets combine sign + top 7 bits of exponent
	or	b
	ld	d,a
	ld	h,l	;Shuffle mantissa
	ld	l,0
	ret

