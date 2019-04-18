
	SECTION	code_fp_mbfs

	PUBLIC	l_f32_ge
	EXTERN	___mbfs_setup_comparison
	EXTERN	l_f32_yes
	EXTERN	l_f32_no

; Stack >= registers
l_f32_ge:
	call	___mbfs_setup_comparison
	; 0b00000000 = stack == register
	; 0b00000001 = stack > register
	; 0b11111111 = stack < register
	inc	a
	jp	z,l_f32_no
	jp	l_f32_yes
