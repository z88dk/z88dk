
	SECTION	code_fp_math32
	PUBLIC	tanh
	EXTERN	cm32_sccz80_tanh

	defc	tanh = cm32_sccz80_tanh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tanh
defc _tanh = tanh
ENDIF

