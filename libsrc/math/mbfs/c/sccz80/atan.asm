
        SECTION code_fp_mbfs

        PUBLIC  atan
        EXTERN  fp_setup_atangle
        EXTERN  ATN
        EXTERN  fp_return

atan:
	call	fp_setup_atangle
	call	ATN
	jp	fp_return
