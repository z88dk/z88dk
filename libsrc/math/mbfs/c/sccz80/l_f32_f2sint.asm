
	SECTION	code_fp_mbfs

	PUBLIC	l_f32_f2sint
	PUBLIC	l_f32_f2uint
	PUBLIC	l_f32_f2ulong
	PUBLIC	l_f32_f2slong
	EXTERN	___mbfs_setup_single_reg
	EXTERN	___mbfs_return
	EXTERN	___mbfs_FPINT
	EXTERN	___mbfs_FPREG
	EXTERN	___mbfs_FPEXP
	EXTERN	msbios


l_f32_f2sint:
l_f32_f2uint:
l_f32_f2slong:
l_f32_f2ulong:
	call	___mbfs_setup_single_reg
	ld	a,(___mbfs_FPREG + 2)
	push	af
	ld	a,(___mbfs_FPEXP)
	ld	ix,___mbfs_FPINT
	call	msbios
	pop	ix
	ex	de,hl
	ld	e,c
	ld	d,0
	pop	af	;Get sign bit back
	rlca
	ret	nc	;Wasn't negative, set MSB to 0
	dec	d	;It was, so to 0xff
	ret
