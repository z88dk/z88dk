
	SECTION		code_fp_mbf64

	PUBLIC		floor
	EXTERN		___mbf64_discard_fraction
	EXTERN		___mbf64_FA
	EXTERN		___mbf64_FPARG
	EXTERN		___mbf64_FPREG
	EXTERN		___mbf64_FPSUB
	EXTERN		___mbf64_UNITY
	EXTERN		___mbf64_return
	EXTERN		msbios

floor:
	call	___mbf64_discard_fraction
	ld	a,(___mbf64_FA+6)
	rlca
	ret	nc		;It was positive
	; Otherwise we have to subtract 1
	ld      hl,___mbf64_FA
        ld      de,___mbf64_FPREG
        ld      bc,8
        ldir
	ld	hl,___mbf64_UNITY
	ld	de,___mbf64_FPARG
	ld	bc,8
	ldir
	push	ix
	ld	ix,___mbf64_FPSUB
	call	msbios
	jp	___mbf64_return



