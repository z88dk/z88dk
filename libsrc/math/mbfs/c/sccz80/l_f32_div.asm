
	SECTION	code_fp_mbfs

	PUBLIC	l_f32_div
	EXTERN	___mbfs_setup_arith
	EXTERN	___mbfs_DVBCDE
	EXTERN	___mbfs_return
	EXTERN	msbios

l_f32_div:
	call	___mbfs_setup_arith
	ld	ix,___mbfs_DVBCDE
	call	msbios
	jp	___mbfs_return


