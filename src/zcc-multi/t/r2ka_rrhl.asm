; Rabbit native rr hl is 2 T (FC). Not two CB ops.
; rr hl + ret = 2 + 8 = 10 T.
	MODULE	t_r2ka_rrhl

	SECTION	code_compiler

._foo
	rr	hl
	ret

	SECTION	code_compiler
	GLOBAL	_foo
