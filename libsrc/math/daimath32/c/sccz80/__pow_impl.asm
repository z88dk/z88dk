
        SECTION code_fp_dai32

        PUBLIC  __pow_impl
        EXTERN  ___dai32_setup_two
        EXTERN  ___dai32_xpwr
        EXTERN  ___dai32_return

__pow_impl:
	call	___dai32_setup_two
	call	___dai32_xpwr
	jp	___dai32_return
