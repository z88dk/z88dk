
	SECTION	code_fp_am9511
	PUBLIC	tanh
	EXTERN	cam32_sccz80_tanh

	defc	tanh = cam32_sccz80_tanh


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tanh
defc _tanh = cam32_sccz80_tanh
ENDIF

