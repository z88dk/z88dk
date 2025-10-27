
	SECTION	code_fp_am9511
	PUBLIC	neg_fastcall
	EXTERN	asm_am9511_neg

	defc	neg_fastcall = asm_am9511_neg


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _neg_fastcall
defc _neg_fastcall = asm_am9511_neg
ENDIF

