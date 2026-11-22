; Larger, faster gbz80 body: ld a,(hl+) + 18 nop + ret = 96 T, 20 bytes.
	MODULE	t_gbz80_fast

	SECTION	code_compiler

._foo
	ld	a,(hl+)
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	ret

	SECTION	code_compiler
	GLOBAL	_foo
