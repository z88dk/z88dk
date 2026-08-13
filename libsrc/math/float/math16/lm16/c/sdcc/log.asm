
	SECTION code_clib
	SECTION	code_fp_math16
	PUBLIC	_logf16
	EXTERN	cm16_sdcc_log

	defc	_logf16 = cm16_sdcc_log
