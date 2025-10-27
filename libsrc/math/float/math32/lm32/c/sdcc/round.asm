
	SECTION	code_fp_math32
	PUBLIC	_round
	EXTERN	cm32_sdcc_round

	defc	_round = cm32_sdcc_round
