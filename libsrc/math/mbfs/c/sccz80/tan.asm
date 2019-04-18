
        SECTION code_fp_mbfs

        PUBLIC  tan
        EXTERN  fp_setup_tangle
        EXTERN  TAN
        EXTERN  fp_return

tan:
	call	fp_setup_tangle
	call	TAN
	jp	fp_return
