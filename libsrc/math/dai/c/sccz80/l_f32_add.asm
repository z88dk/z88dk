
	SECTION	code_fp_dai32

	PUBLIC	l_f32_add
	EXTERN	___dai32_setup_arith
	EXTERN	___dai32_xfadd
	EXTERN	___dai32_return


l_f32_add:
	call	___dai32_setup_arith
	call	___dai32_xfadd
	jp	    ___dai32_return


