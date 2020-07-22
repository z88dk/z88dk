
        SECTION code_fp_dai32

        PUBLIC  sin
        EXTERN  ___dai32_setup_single
        EXTERN  ___dai32_xsin
        EXTERN  ___dai32_return

sin:
	call	___dai32_setup_single
	call	___dai32_xsin
	jp	___dai32_return
