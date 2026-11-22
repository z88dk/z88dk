
	SECTION	code_fp_math32
	PUBLIC	_frexp
	EXTERN	cm32_sdcc_frexp

	defc	_frexp = cm32_sdcc_frexp
