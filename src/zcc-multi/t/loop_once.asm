; Fixture: one increment, no loop.
	MODULE	t_loop_once

	SECTION	code_compiler

._foo
	inc	hl
	ret

	SECTION	code_compiler
	GLOBAL	_foo
