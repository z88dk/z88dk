
	SECTION	code_fp_mbfs

	PUBLIC	l_f32_mul
	EXTERN	___mbfs_setup_arith
	EXTERN	___mbfs_FPMULT
	EXTERN	___mbfs_return
	EXTERN	msbios


l_f32_mul:
	call	___mbfs_setup_arith
	ld	ix,___mbfs_FPMULT
	call	msbios
	jp	___mbfs_return


