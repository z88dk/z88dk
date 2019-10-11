
	SECTION	code_fp_mbf64

	PUBLIC	l_f64_lt
	EXTERN	l_f64_yes
	EXTERN	l_f64_no
	EXTERN	___mbf64_setup_comparison

	INCLUDE	"mbf64.def"

; Stack < registers
l_f64_lt:
	call	___mbf64_setup_comparison
	; 0b00000000 = stack == register
	; 0b00000001 = stack > register
	; 0b11111111 = stack < register
	inc	a
	jp	z,l_f64_yes
	jp	l_f64_no
