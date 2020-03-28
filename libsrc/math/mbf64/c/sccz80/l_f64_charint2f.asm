        MODULE  l_f64_uchar2f
        SECTION code_fp_mbf64

        PUBLIC  l_f64_uchar2f
        PUBLIC  l_f64_uint2f
        PUBLIC  l_f64_schar2f
        PUBLIC  l_f64_sint2f

	EXTERN	___mbf64_set_zero
        EXTERN  l_neg_hl
	EXTERN	___mbf64_FA
        EXTERN  msbios


; Convert signed char/int in l to floating point value in FA
; TODO: Optimise the char case
l_f64_uchar2f:
l_f64_uint2f:
        ld      c,0
        jr      not_negative
l_f64_schar2f:
l_f64_sint2f:
        ld      c,0
        bit     7,h
        jr      z,not_negative
        call    l_neg_hl
	ld	c,128
not_negative:
	ld	b,$80 + 16
	ld	a,h
	or	l
	jp	z,___mbf64_set_zero
loop:
	bit	7,h
	jr	nz,rotate_done
	sla	l
	rl	h
	dec	b
	jr	loop
rotate_done:
	ld	a,h
	and	127
	or	c		;Restore sign bit
	ld	h,a
	ld	(___mbf64_FA+5),hl
	ld	hl,0
	ld	(___mbf64_FA+0),hl
	ld	(___mbf64_FA+1),hl
	ld	(___mbf64_FA+3),hl
	ld	a,b		;Set exponent
	ld	(___mbf64_FA+7),a
	ret



