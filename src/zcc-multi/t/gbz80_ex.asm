; gbz80 ex de,hl = 56 T (push hl / push de / pop hl / pop de).
; 20 nop + ret = 80+16. Total 152 T, 25 bytes.
	MODULE	t_gbz80_ex

	SECTION	code_compiler

._foo
	ex	de,hl
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
	nop
	nop
	ret

	SECTION	code_compiler
	GLOBAL	_foo
