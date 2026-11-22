; Swapped litq. Offset 0 is the second data-variant string. _foo is the small body.
	MODULE	str_diff_sp

	SECTION	code_compiler

._foo
	ld	hl,i_1+0
	ret

._bar
	ld	hl,1
	ld	a,(hl)
	ret

; --- Start of Optimiser additions ---
	SECTION	rodata_compiler
.i_1
	defm	"World"
	defb	0
	defm	"Hello"
	defb	0

; --- Start of Static Variables ---
	SECTION	bss_compiler
._g
	defs	2

; --- Start of Scope Defns ---
	GLOBAL	_foo
	GLOBAL	_bar
	GLOBAL	_g
