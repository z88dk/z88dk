

	SECTION		code_fp_mbf64

	PUBLIC		l_f64_f2slong
	PUBLIC		l_f64_f2ulong
	PUBLIC		l_f64_f2sint
	PUBLIC		l_f64_f2uint

	EXTERN		___mbf64_FA
	EXTERN		l_long_neg

; Convert floating point number to long
;
; TODO: Optimise the integer case by not doing a full 32 bit shift
l_f64_f2sint:
l_f64_f2uint:
l_f64_f2slong:
l_f64_f2ulong:
	; TODO: Call floor beforehand
	ld	hl,0				;Inital result
	ld	de,0
	ld	a,(___mbf64_FA + 7)		;exponent
	and	a
	ret	z
	cp	$80 + 32
	ret	nc				;Number too big
	ld	de,(___mbf64_FA + 5)		;MSW
	ld	hl,(___mbf64_FA + 3)		;NMSW
	ld	c,d				;Save sign bit
	set	7,d				;Restore hidden bit
loop:
	srl	d
	rr	e
	rr	h
	rr	l
	inc	a
	cp	$80 + 32
	jr	nz,loop
	rl	c
	ret	nc
	jp	l_long_neg
