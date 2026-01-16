
	SECTION	code_fp_math32
	PUBLIC	pow
	EXTERN	cm32_sccz80_pow

	defc	pow = cm32_sccz80_pow


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _pow
defc _pow = pow
ENDIF

; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___pow
defc ___pow = pow
ENDIF


