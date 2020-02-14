
	SECTION	code_clib
	PUBLIC	load_palette
	PUBLIC	_load_palette
	EXTERN	asm_load_palette

	defc	load_palette = asm_load_palette
	defc	_load_palette = load_palette


