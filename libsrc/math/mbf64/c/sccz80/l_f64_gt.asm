
	SECTION	code_fp_mbf64

	PUBLIC	l_f64_gt
	EXTERN	___mbf64_setup_comparison
	EXTERN	l_f64_yes
	EXTERN	l_f64_no

	INCLUDE	"mbf64.def"

; Stack > registers
l_f64_gt:
	call	___mbf64_setup_comparison
	; 0b00000000 = stack == register
	; 0b00000001 = stack > register
	; 0b11111111 = stack < register
	cp	1
	jp	z,l_f64_yes
	jp	l_f64_no
	
