
	SECTION	code_fp_mbfs

	PUBLIC	l_f32_lt
	EXTERN	l_f32_yes
	EXTERN	l_f32_no
	EXTERN	fp_setup_comparison

; Stack < registers
l_f32_lt:
	call	fp_setup_comparison
	; 0b00000000 = stack == register
	; 0b00000001 = stack > register
	; 0b11111111 = stack < register
	inc	a
	jp	z,l_f32_yes
	jp	l_f32_no
