
	SECTION	code_fp_math16
	PUBLIC	powf16
	EXTERN	cm16_sccz80_pow

	defc	powf16 = cm16_sccz80_pow


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _powf16
EXTERN	powf16
defc _powf16 = powf16
ENDIF

