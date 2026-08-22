; Z80 ld hl,(ix+0) is two indexed byte loads: 19+19 = 38 T. Plus ret 10 = 48.
	MODULE	t_ixword

	SECTION	code_compiler

._foo
	ld	hl,(ix+0)
	ret

	SECTION	code_compiler
	GLOBAL	_foo
