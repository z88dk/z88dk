
        SECTION code_fp_mbfs

        PUBLIC  fabs
        EXTERN  fp_setup_fabsgle
        EXTERN  ABS
        EXTERN  fp_return

fabs:
	call	fp_setup_fabsgle
	call	ABS
	jp	fp_return
