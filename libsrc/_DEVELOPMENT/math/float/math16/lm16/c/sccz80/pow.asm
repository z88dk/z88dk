
	SECTION	code_fp_math16
	PUBLIC	pow
	EXTERN	cm16_sccz80_pow

	defc	pow = cm16_sccz80_pow


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _pow
EXTERN	powf16
defc _pow = powf16
ENDIF

