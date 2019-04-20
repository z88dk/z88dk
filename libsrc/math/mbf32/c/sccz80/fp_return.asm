

        SECTION         code_fp_mbf32

	PUBLIC		___mbf32_return

	EXTERN		___mbf32_FPREG

; Return the value that's in the DAC
___mbf32_return:
	ld	hl,(___mbf32_FPREG)
	ld	de,(___mbf32_FPREG+2)
	pop	ix
	ret
