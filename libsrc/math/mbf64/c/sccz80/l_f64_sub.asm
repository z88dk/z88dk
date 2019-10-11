
	SECTION	code_fp_mbf64

	PUBLIC	l_f64_sub
	EXTERN	___mbf64_setup_arith

	INCLUDE	"mbf64.def"


l_f64_sub:
	call	___mbf64_setup_arith
	ld	ix,___mbf64_FPSUB
	call	msbios
	jp	___mbf64_return


