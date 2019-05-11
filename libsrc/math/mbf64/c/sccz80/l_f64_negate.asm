

        SECTION code_fp_mbf64

        PUBLIC  l_f64_negate

	EXTERN	___mbf64_FA


l_f64_negate:
	ld	hl,___mbf64_FA + 6
	ld	a,(hl)
	xor	$80
	ld	(hl),a
	ret
