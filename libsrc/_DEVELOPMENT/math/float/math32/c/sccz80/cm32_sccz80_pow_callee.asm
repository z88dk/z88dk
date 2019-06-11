
SECTION code_fp_math32
PUBLIC cm32_sccz80_pow_callee

EXTERN _m32_powf


cm32_sccz80_pow_callee:
	pop	af	; return
	pop	hl	; RHS
	pop de
	exx
	pop hl  ; LHS
	pop de
	push af ; return
	exx
	push de ; RHS
	push hl
	exx
	push de ; LHS
	push hl
	call _m32_powf
	pop bc
	pop bc
	pop bc
	pop bc
	ret     ; return
