
        SECTION         code_fp_mbf32

        PUBLIC          ___mbf32_set_zero
        EXTERN          ___mbf32_FPREG

___mbf32_set_zero:
	ld	hl,0
	ld	(___mbf32_FPREG),hl
	ld	(___mbf32_FPREG+2),hl
	ret
