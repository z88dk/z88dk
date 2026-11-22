
	SECTION	code_fp_am9511
	PUBLIC	pow
	EXTERN	cam32_sccz80_pow

	defc	pow = cam32_sccz80_pow


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _pow
EXTERN	asm_am9511_pow
defc _pow = asm_am9511_pow
ENDIF

