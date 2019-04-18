
        SECTION code_fp_mbfs

        PUBLIC  exp
        EXTERN  fp_setup_expgle
        EXTERN  EXP
        EXTERN  fp_return

exp:
	call	fp_setup_expgle
	call	EXP
	jp	fp_return
