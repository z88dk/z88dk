; Rabbit ld hl,(ix+0) is native E4, 9 T. Plus ret 8 = 17.
; Z80 two-byte form is 38 T. Must not fallback.
	MODULE	t_r2ka_ldix

	SECTION	code_compiler

._foo
	ld	hl,(ix+0)
	ret

	SECTION	code_compiler
	GLOBAL	_foo
