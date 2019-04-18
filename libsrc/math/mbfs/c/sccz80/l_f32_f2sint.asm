
	SECTION	code_fp_mbfs

	PUBLIC	l_f32_f2sint
	PUBLIC	l_f32_f2uint
	PUBLIC	l_f32_f2ulong
	PUBLIC	l_f32_f2slong
	EXTERN	___mbfs_setup_single_reg
	EXTERN	___mbfs_return
	EXTERN	___mbfs_FPINT
	EXTERN	___mbfs_FPREG
	EXTERN	msbios


l_f32_f2sint:
l_f32_f2uint:
l_f32_f2slong:
l_f32_f2ulong:
	call	___mbfs_setup_single_reg
	ld	ix,___mbfs_FPINT
	call	msbios
	pop	ix
	ex	de,hl
	ld	d,b
	ld	e,c
	ret
