; Smallest usable body: 3 * ex (sp),hl + ret = 67 T, 4 bytes.
	MODULE	t_mix_small

	SECTION	code_compiler

._foo
	ex	(sp),hl
	ex	(sp),hl
	ex	(sp),hl
	ret

	SECTION	code_compiler
	GLOBAL	_foo
