; Fixture: sccz80-like. Larger _foo. Smaller _bar.
	MODULE	opt_sccz80

	SECTION	code_compiler

._foo
	jp	i_8
.i_8
	ld	hl,1
	ret

._bar
	ld	hl,1
	ret

; --- Start of Optimiser additions ---
	defc	i_10 = i_8
	defc	i_11 = i_10

; --- Start of Static Variables ---
	SECTION	bss_compiler
._g
	defs	2
	SECTION	code_compiler

; --- Start of Scope Defns ---
	GLOBAL	_foo
	GLOBAL	_bar
	GLOBAL	_g
