
        SECTION code_fp_mbf32

        PUBLIC  atan
        EXTERN  ___mbf32_setup_single
        EXTERN  ___mbf32_ATN
        EXTERN  ___mbf32_return
	EXTERN	msbios

atan:
	call	___mbf32_setup_single
IF __CPU_INTEL__ || __CPU_GBZ80__
	call	___mbf32_ATN
ELSE
	ld	ix,___mbf32_ATN
	call	msbios
ENDIF
	jp	___mbf32_return
