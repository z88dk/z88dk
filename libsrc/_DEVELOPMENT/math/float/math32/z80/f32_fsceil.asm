SECTION code_clib
SECTION	code_fp_math32

EXTERN	m32_f2ulong
EXTERN	m32_float32u
EXTERN	m32_float32
EXTERN	m32_unity
EXTERN	m32_fsadd_callee

PUBLIC  m32_ceil_fastcall
PUBLIC	_m32_ceilf


; float ceilf(float f) __z88dk_fastcall;
._m32_ceilf

; Entry: dehl = floating point number
.m32_ceil_fastcall
	bit	7,d
	push	af			;Save sign flag
	call	m32_f2ulong		;Exits dehl = number
	pop	af
	jr	Z,was_positive
	call	m32_float32
	ret
.was_positive
	call	m32_float32u
	; Add 1
	push	de
	push	hl
	call	m32_unity
	call	m32_fsadd_callee
	ret


