
    SECTION	code_fp_am9511
    PUBLIC	l_f32_eq
    EXTERN	asm_am9511_compare_callee


.l_f32_eq
	call asm_am9511_compare_callee
	scf
	ret	Z
	ccf
	dec	hl
	ret
