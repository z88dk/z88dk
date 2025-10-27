
	SECTION	code_fp_math32
	PUBLIC	_neg
	EXTERN	cm32_sdcc_fsneg

	defc	_neg = cm32_sdcc_fsneg
