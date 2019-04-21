

        SECTION code_fp_mbf64

        PUBLIC  l_f64_store

	EXTERN	___mbf64_FA


l_f64_store:
	ld	de,___mbf64_FA
	ld	bc,8
	ex	de,hl
	ldir
	ex	de,hl
	ret
