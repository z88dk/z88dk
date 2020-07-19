
	SECTION	code_fp_dai32

	PUBLIC	l_f32_mul
	EXTERN	___dai32_setup_arith
	EXTERN	___dai32_xfmul
	EXTERN	___dai32_return


l_f32_mul:
	call	___dai32_setup_arith
	call	___dai32_xfmul
	jp	___dai32_return


