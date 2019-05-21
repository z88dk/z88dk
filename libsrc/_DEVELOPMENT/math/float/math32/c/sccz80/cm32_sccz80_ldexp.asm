
SECTION code_fp_math32

PUBLIC cm32_sccz80_ldexp

EXTERN _m32_ldexpf

; float ldexpf(float x, int pw2);
cm32_sccz80_ldexp:
	; Entry:
	; Stack: float left, int right, ret

	; Reverse the stack
	pop	af	;ret
	pop	bc	;int
	pop	hl	;float
	pop	de
	push	bc	;int
	push	de	;float
	push	hl
	push	af	;ret
	jp	_m32_ldexpf
	
