        MODULE  l_f64_long2f
        SECTION code_fp_mbf64

        PUBLIC  l_f64_ulong2f
        PUBLIC  l_f64_slong2f

        EXTERN  l_long_neg
	EXTERN	___mbf64_FA
	EXTERN	___mbf64_set_zero
        EXTERN  msbios


; Convert signed char/int in l to floating point value in FA
; TODO: Optimise the char case
l_f64_ulong2f:
        ld      c,0
        jr      not_negative
l_f64_slong2f:
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
	jp	z,___mbf64_set_zero
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
	ld	a,d
	and	127
	or	c		;Restore sign bit
	ld	d,a
	ld	(___mbf64_FA+5),de
	ld	(___mbf64_FA+3),hl
	ld	hl,0
	ld	(___mbf64_FA+0),hl
	ld	(___mbf64_FA+1),hl
	ld	a,b		;Set exponent
	ld	(___mbf64_FA+7),a
	ret



