
	SECTION	code_fp_mbf64

	PUBLIC	l_f64_add
	EXTERN	___mbf64_setup_arith

	INCLUDE	"mbf64.def"


l_f64_add:
	call	___mbf64_setup_arith
	ld	ix,___mbf64_FPADD
	call	msbios
	jp	___mbf64_return


