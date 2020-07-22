
	SECTION	code_fp_dai32

	PUBLIC	l_f32_div
	EXTERN	___dai32_setup_arith
	EXTERN	___dai32_xfdiv
	EXTERN	___dai32_return

l_f32_div:
	call	___dai32_setup_arith
	call	___dai32_xfdiv
	jp	___dai32_return


