; Z80 ld iy,hl is push hl / pop iy = 25 T. Plus ret 10 = 35.
; Rabbit native FD 7D is 4 T (plus ret 10 = 14). Must not fallback.
	MODULE	t_iyld

	SECTION	code_compiler

._foo
	ld	iy,hl
	ret

	SECTION	code_compiler
	GLOBAL	_foo
