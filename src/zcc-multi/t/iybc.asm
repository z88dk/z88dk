; Z80/Z80N ld iy,bc is two prefixed 8-bit loads = 16 T. Plus ret 10 = 26.
; Z180 has no index halves: push bc / pop iy = 25 T. Plus ret 10 = 35.
	MODULE	t_iybc

	SECTION	code_compiler

._foo
	ld	iy,bc
	ret

	SECTION	code_compiler
	GLOBAL	_foo
