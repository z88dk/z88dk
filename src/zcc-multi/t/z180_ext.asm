; Z180 extras (Zilog). Total 94:
;   mlt de 17, in0 a,(n) 12, out0 (n),a 13, tst a 7, tst n 9,
;   tstio n 12, otim 14, ret 10.
	MODULE	t_z180_ext

	SECTION	code_compiler

._foo
	mlt	de
	in0	a,(0)
	out0	(0),a
	tst	a
	tst	0
	tstio	0
	otim
	ret

	SECTION	code_compiler
	GLOBAL	_foo
