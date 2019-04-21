

        SECTION code_fp_mbf64

        PUBLIC  l_f64_load

	EXTERN	___mbf64_FA


l_f64_load:
	ld	de,___mbf64_FA
	ld	bc,8
	ldir
	ret
