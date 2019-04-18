
	SECTION	code_fp_mbfs

	PUBLIC	l_f32_ne
	EXTERN	l_f32_yes
	EXTERN	l_f32_no
	EXTERN	fp_setup_comparison

; Stack == registers
l_f32_ne:
	call	fp_setup_comparison
	; 0b00000000 = stack == register
	; 0b00000001 = stack > register
	; 0b11111111 = stack < register
	and	a
	jp	nz,l_f32_yes
	jp	l_f32_no
