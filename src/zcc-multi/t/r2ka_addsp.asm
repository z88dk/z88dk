; Rabbit add sp,n is native (27 nn), 4 T. Plus ret 10 = 14.
	MODULE	t_r2ka_addsp

	SECTION	code_compiler

._foo
	add	sp,2
	ret

	SECTION	code_compiler
	GLOBAL	_foo
