
        SECTION code_fp_mbfs

        PUBLIC  sqrt
        EXTERN  fp_setup_sqrtgle
        EXTERN  SQR
        EXTERN  fp_return

sqrt:
	call	fp_setup_sqrtgle
	call	SQR
	jp	fp_return
