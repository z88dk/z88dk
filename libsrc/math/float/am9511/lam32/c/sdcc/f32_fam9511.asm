
	SECTION	code_fp_am9511

	PUBLIC	_f32_fam9511_fastcall
	EXTERN	asm_f32_am9511

	defc	_f32_fam9511_fastcall = asm_f32_am9511


	PUBLIC	_f32_fam9511
	EXTERN	cam32_sdcc_f32_fam9511

	defc	_f32_fam9511 = cam32_sdcc_f32_fam9511


	PUBLIC	_fam9511_f32_fastcall
	EXTERN	asm_am9511_f32

	defc	_fam9511_f32_fastcall = asm_am9511_f32


	PUBLIC	_fam9511_f32
	EXTERN	cam32_sdcc_fam9511_f32

	defc	_fam9511_f32 = cam32_sdcc_fam9511_f32

