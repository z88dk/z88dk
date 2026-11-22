; Z80 ld hl,(iy+0) is two indexed byte loads: 19+19 = 38 T. Plus ret 10 = 48.
	MODULE	t_iyword

	SECTION	code_compiler

._foo
	ld	hl,(iy+0)
	ret

	SECTION	code_compiler
	GLOBAL	_foo
