; Z80N extras (Zilog). Total 175:
;   mul de 8, nextreg n,n 20, nextreg n,a 17, add hl,a 8, add de,imm16 16,
;   push imm16 23, swapnib 8, mirror a 8, test n 11, bsla de,b 8,
;   outinb 16, pixelad 8, ldws 14, ret 10.
	MODULE	t_z80n_ext

	SECTION	code_compiler

._foo
	mul	de
	nextreg	0,0
	nextreg	0,a
	add	hl,a
	add	de,1
	push	1234h
	swapnib
	mirror	a
	test	0
	bsla	de,b
	outinb
	pixelad
	ldws
	ret

	SECTION	code_compiler
	GLOBAL	_foo
