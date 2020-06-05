
SECTION code_fp_math16

PUBLIC cm16_sdcc___schar2h_callee

EXTERN asm_f24_i16
EXTERN asm_f16_f24

.cm16_sdcc___schar2h_callee
	pop	bc	;return
	pop	hl	;value
	dec	sp
	push	bc
	ld	a,l
	rlca	
	sbc	a
	ld	h,a
	call asm_f24_i16
	jp asm_f16_f24

