
SECTION code_fp_math32

PUBLIC cm32_sccz80_frexp

EXTERN _m32_frexpf

; float frexpf(float x, int *pw2);
cm32_sccz80_frexp:
	; Entry:
	; Stack: float left, ptr right, ret

	; Reverse the stack
	pop	af	;ret
	pop	bc	;ptr
	pop	hl	;float
	pop	de
	push	bc	;ptr
	push	de	;float
	push	hl
	push	af	;ret
	jp	_m32_frexpf
