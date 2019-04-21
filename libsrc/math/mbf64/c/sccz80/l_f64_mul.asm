
	SECTION	code_fp_mbf64

	PUBLIC	l_f64_mul
	EXTERN	fp_setup_arith

	INCLUDE	"mbf64.def"


l_f64_mul:
	call	fp_setup_arith
	ld	ix,___mbf64_FPMUL
	call	msbios
	jp	fp_return


