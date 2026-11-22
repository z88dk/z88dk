; Rabbit native rr hl is 2 T (FC). Not two CB ops.
; rr hl + ret = 12 T with the Z80 ret stand-in (10).
	MODULE	t_r2ka_rrhl

	SECTION	code_compiler

._foo
	rr	hl
	ret

	SECTION	code_compiler
	GLOBAL	_foo
