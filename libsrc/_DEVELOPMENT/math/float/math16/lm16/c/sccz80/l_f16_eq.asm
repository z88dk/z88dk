
    SECTION	code_fp_math16
    PUBLIC	l_f16_eq
    EXTERN	asm_f16_compare_callee


.l_f16_eq
	call asm_f16_compare_callee
	scf
	ret	Z
	ccf
	dec	hl
	ret
