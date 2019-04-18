

        SECTION         code_fp_mbfs

	PUBLIC		fp_return

	EXTERN		FPREG

; Return the value that's in the DAC
fp_return:
	ld	hl,(FPREG)
	ld	de,(FPREG+2)
	ret
