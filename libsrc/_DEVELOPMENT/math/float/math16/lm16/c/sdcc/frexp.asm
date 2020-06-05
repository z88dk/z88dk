
	SECTION	code_fp_math16
	PUBLIC	_frexp
	EXTERN	cm16_sdcc_frexp

	defc	_frexp = cm16_sdcc_frexp
