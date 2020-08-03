
        SECTION code_fp_mbf32

        PUBLIC  exp
        EXTERN  ___mbf32_setup_single
        EXTERN  ___mbf32_EXP
        EXTERN  ___mbf32_return
	EXTERN	msbios

exp:
	call	___mbf32_setup_single
IF __CPU_INTEL__ || __CPU_GBZ80__
	call	___mbf32_EXP
ELSE
	ld	ix,___mbf32_EXP
	call	msbios
eNDIF
	jp	___mbf32_return
