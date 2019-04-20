
	SECTION	code_fp_mbfs

	PUBLIC	l_f32_sub
	EXTERN	___mbfs_setup_arith
	EXTERN	___mbfs_SUBCDE
	EXTERN	___mbfs_return
	EXTERN	msbios


l_f32_sub:
	call	___mbfs_setup_arith
	ld	ix,___mbfs_SUBCDE
	call	msbios
	jp	___mbfs_return


