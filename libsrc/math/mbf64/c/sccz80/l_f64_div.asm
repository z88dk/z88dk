
	SECTION	code_fp_mbf64

	PUBLIC	l_f64_div
	EXTERN	fp_setup_arith

	INCLUDE	"mbf64.def"


l_f64_div:
	call	fp_setup_arith
	ld	ix,___mbf64_FPDIV
	call	msbios
	jp	fp_return


