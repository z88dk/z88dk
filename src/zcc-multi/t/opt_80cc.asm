; Fixture: 80cc-like. Smaller _foo. Larger _bar.
	MODULE	opt_80cc

	SECTION	code_compiler

._foo
	ld	hl,1
	ret

._bar
	ld	hl,1
	ld	de,0
	add	hl,de
	add	hl,de
	add	hl,de
	ret

; --- Start of Optimiser additions ---

; --- Start of Static Variables ---
	SECTION	bss_compiler
._g
	defs	2
	SECTION	code_compiler

; --- Start of Scope Defns ---
	GLOBAL	_foo
	GLOBAL	_bar
	GLOBAL	_g
