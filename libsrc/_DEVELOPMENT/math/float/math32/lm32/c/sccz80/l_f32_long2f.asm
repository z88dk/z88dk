        MODULE  l_f32_long2f
        SECTION code_fp_math32

        PUBLIC  l_f32_ulong2f
        PUBLIC  l_f32_slong2f

        EXTERN  l_long_neg
	EXTERN	l_f32_zero


; Convert signed char/int in l to floating point value in FA
; TODO: Optimise the char case
l_f32_ulong2f:
        ld      c,0
        jr      not_negative
l_f32_slong2f:
        ld      c,0
        bit     7,h
        jr      z,not_negative
        call    l_long_neg
	ld	c,128
not_negative:
	ld	a,h
	or	l
	or	e
	or	d
	jp	z,l_f32_zero
	ld	b,$80 + 32
loop:
	bit	7,d
	jr	nz,rotate_done
	sla	l
	rl	h
	rl	e
	rl	d
	dec	b
	jr	loop
rotate_done:
	; We're only concerned about dhl since we only have a 24 bit mantissa
	rl	d	;Shift mantissa by one bit
	srl	b	;And exponent
	rr	d	;And get exponent lowest bit into mantissa field
	; Shuffle down
	ld	l,h
	ld	h,e
	ld	e,d
	ld	a,c	;Combine sign bit + 7 bits of mantissa
	or	b
	ld	d,a
	ret



