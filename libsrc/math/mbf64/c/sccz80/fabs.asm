

        SECTION code_fp_mbf64

        PUBLIC  fabs

	EXTERN	___mbf64_FA


fabs:
	ld	hl,___mbf64_FA + 6
	res	7,(hl)		;Turn off sign bit
	ret
