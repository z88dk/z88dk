
	SECTION	code_fp_mbf32

	PUBLIC	l_f32_f2sint
	PUBLIC	l_f32_f2uint
	PUBLIC	l_f32_f2ulong
	PUBLIC	l_f32_f2slong
	EXTERN	___mbf32_setup_single_reg
	EXTERN	___mbf32_return
	EXTERN	___mbf32_FPINT
	EXTERN	___mbf32_FPREG
	EXTERN	___mbf32_FPEXP
	EXTERN	msbios


l_f32_f2sint:
l_f32_f2uint:
l_f32_f2slong:
l_f32_f2ulong:
	call	___mbf32_setup_single_reg
	ld	a,(___mbf32_FPREG + 2)
	push	af
	ld	a,(___mbf32_FPEXP)
IF __CPU_INTEL__ || __CPU_GBZ80__
	call	___mbf32_FPINT
ELSE
	ld	ix,___mbf32_FPINT
	call	msbios
	pop	ix
ENDIF
	ex	de,hl
	ld	e,c
	ld	d,0
	pop	af	;Get sign bit back
	rlca
	ret	nc	;Wasn't negative, set MSB to 0
	dec	d	;It was, so to 0xff
	ret
