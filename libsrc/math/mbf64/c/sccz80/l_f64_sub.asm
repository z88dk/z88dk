
	SECTION	code_fp_mbf64

	PUBLIC	l_f64_sub
	EXTERN	fp_setup_arith

	INCLUDE	"mbf64.def"


l_f64_sub:
	call	fp_setup_arith
	ld	ix,___mbf64_FPSUB
	call	msbios
	jp	fp_return


