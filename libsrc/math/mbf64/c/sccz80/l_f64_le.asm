
	SECTION	code_fp_mbf64

	PUBLIC	l_f64_le
	EXTERN	l_f64_yes
	EXTERN	l_f64_no
	EXTERN	___mbf64_setup_comparison

	INCLUDE	"mbf64.def"

; Stack <= registers
l_f64_le:
	call	___mbf64_setup_comparison
	; 0b00000000 = stack == register
	; 0b00000001 = stack > register
	; 0b11111111 = stack < register
	cp	1
	jp	z,l_f64_no
	jp	l_f64_yes
