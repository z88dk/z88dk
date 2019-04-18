
        SECTION code_fp_mbfs

        PUBLIC  sin
        EXTERN  fp_setup_single
        EXTERN  SIN
        EXTERN  fp_return

sin:
	call	fp_setup_single
	call	SIN
	jp	fp_return
