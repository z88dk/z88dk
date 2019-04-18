
        SECTION code_fp_mbfs

        PUBLIC  cos
        EXTERN  fp_setup_single
        EXTERN  COS
        EXTERN  fp_return

cos:
	call	fp_setup_single
	call	COS
	jp	fp_return
