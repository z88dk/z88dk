

        SECTION         code_fp_mbf32

        PUBLIC          floor
	EXTERN		msbios
	EXTERN		___mbf32_setup_single
	EXTERN		___mbf32_return
	EXTERN		___mbf32_FPADD
        EXTERN          ___mbf32_FPREG
	EXTERN		___mbf32_discard_fraction


floor:
	call	___mbf32_setup_single
	call	___mbf32_discard_fraction
	ld	a,(___mbf32_FPREG+2)		;sign
	rlca
	jp	nc,___mbf32_return
	; This is negative, so we have to subtract one
	ld	bc,$8180
	ld	de,$0000
IF __CPU_INTEL__|__CPU_GBZ80__
	call	___mbf32_FPADD
ELSE
	ld	ix,___mbf32_FPADD
	call	msbios
ENDIF
	jp	___mbf32_return
