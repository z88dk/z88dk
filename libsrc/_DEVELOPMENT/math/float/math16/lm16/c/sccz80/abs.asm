
	SECTION	code_fp_math16
	PUBLIC	m16_fabs
	EXTERN	asm_f16_fabs

	defc	m16_fabs = asm_f16_fabs


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _m16_fabs
EXTERN cm16_sdcc_fabs
defc _m16_fabs = cm16_sdcc_fabs
ENDIF

