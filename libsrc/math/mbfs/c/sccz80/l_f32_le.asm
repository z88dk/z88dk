
	SECTION	code_fp_mbfs

	PUBLIC	l_f32_le
	EXTERN	l_f32_yes
	EXTERN	l_f32_no
	EXTERN	___mbfs_setup_comparison

; Stack <= registers
l_f32_le:
	call	___mbfs_setup_comparison
	; 0b00000000 = stack == register
	; 0b00000001 = stack > register
	; 0b11111111 = stack < register
	cp	1
	jp	z,l_f32_no
	jp	l_f32_yes
