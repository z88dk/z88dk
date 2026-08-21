; nop+nop+ret is 4+4+10 = 18 T. Beats a mis-scored ld hl,n (was 4+10).
	MODULE	t_nops

	SECTION	code_compiler

._foo
	nop
	nop
	ret

	SECTION	code_compiler
	GLOBAL	_foo
