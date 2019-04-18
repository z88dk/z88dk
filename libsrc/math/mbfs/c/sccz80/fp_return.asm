

        SECTION         code_fp_mbfs

	PUBLIC		___mbfs_return

	EXTERN		___mbfs_FPREG

; Return the value that's in the DAC
___mbfs_return:
	ld	hl,(___mbfs_FPREG)
	ld	de,(___mbfs_FPREG+2)
	pop	ix
	ret
