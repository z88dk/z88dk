
        SECTION code_fp_mbf32

        PUBLIC  cos
        EXTERN  ___mbf32_setup_single
        EXTERN  ___mbf32_COS
        EXTERN  ___mbf32_return
	EXTERN	msbios

cos:
	call	___mbf32_setup_single
IF __CPU_8080__
	call	___mbf32_COS
ELSE
	ld	ix,___mbf32_COS
	call	msbios
ENDIF
	jp	___mbf32_return
