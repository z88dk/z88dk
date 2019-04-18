
	SECTION	code_fp_mbfs

	PUBLIC	l_f32_add
	EXTERN	___mbfs_setup_arith
	EXTERN	___mbfs_FPADD
	EXTERN	___mbfs_return
	EXTERN	msbios


l_f32_add:
	call	___mbfs_setup_arith
	ld	ix,___mbfs_FPADD
	call	msbios
	jp	___mbfs_return


