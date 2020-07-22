
        SECTION code_fp_dai32

        PUBLIC  log
        EXTERN  ___dai32_setup_single
        EXTERN  ___dai32_xln
        EXTERN  ___dai32_return

log:
	call	___dai32_setup_single
	call	___dai32_xln
	jp	___dai32_return
