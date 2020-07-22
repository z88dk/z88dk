
        SECTION code_fp_dai32

        PUBLIC  asin
        EXTERN  ___dai32_setup_single
        EXTERN  ___dai32_xasin
        EXTERN  ___dai32_return

asin:
	call	___dai32_setup_single
	call	___dai32_xasin
	jp	___dai32_return
