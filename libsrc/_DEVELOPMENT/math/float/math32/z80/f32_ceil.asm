
	SECTION	code_fp_math32
	PUBLIC	m32_ceil
	PUBLIC	m32_ceil_fastcall

	EXTERN	m32_f2ulong
	EXTERN	m32_float32u
	EXTERN	m32_float32
	EXTERN	m32_unity
	EXTERN	m32_fsadd_callee

; float ceil(float f)
m32_ceil:
	pop	bc
	pop	hl
	pop	de
	push	de
	push	hl
	push	bc

; Entry: dehl = floating point number
m32_ceil_fastcall:
	bit	7,d
	push	af			;Save sign flag
	call	m32_f2ulong		;Exits dehl = number
	pop	af
	jr	z,was_positive
	call	m32_float32
	ret
was_positive:
	call	m32_float32u
	; Add 1
	push	de
	push	hl
	call	m32_unity
	call	m32_fsadd_callee
	ret


