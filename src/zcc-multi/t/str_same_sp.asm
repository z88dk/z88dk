; Same litq. _bar is the small body.
	MODULE	str_same_sp

	SECTION	code_compiler

._foo
	ld	hl,i_1+0
	nop
	nop
	ret

._bar
	ld	hl,i_1+6
	ret

._baz
	nop
	ret

; --- Start of Optimiser additions ---
	SECTION	rodata_compiler
.i_1
	defm	"Hello"
	defb	0
	defm	"World"
	defb	0

; --- Start of Static Variables ---
	SECTION	bss_compiler
._g
	defs	2

; --- Start of Scope Defns ---
	GLOBAL	_foo
	GLOBAL	_bar
	GLOBAL	_baz
	GLOBAL	_g
