
	SECTION	code_fp_mbfs

	PUBLIC	l_f32_div
	EXTERN	fp_setup_arith
	EXTERN	DVBCDE
	EXTERN	fp_return

l_f32_div:
	call	fp_setup_arith
	call	DVBCDE
	jp	fp_return


