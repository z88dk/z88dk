
	SECTION	code_fp_am9511

	PUBLIC	f32_fam9511_fastcall
	EXTERN	asm_f32_am9511

	defc	f32_fam9511_fastcall = asm_f32_am9511


	PUBLIC	f32_fam9511
	EXTERN	cam32_sccz80_f32_fam9511

	defc	f32_fam9511 = cam32_sccz80_f32_fam9511


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f32_fam9511_fastcall
defc _f32_fam9511_fastcall = asm_f32_am9511
PUBLIC _f32_fam9511
EXTERN cam32_sdcc_f32_fam9511
defc _f32_fam9511 = cam32_sdcc_f32_fam9511
ENDIF

	PUBLIC	fam9511_f32_fastcall
	EXTERN	asm_am9511_f32

	defc	fam9511_f32_fastcall = asm_am9511_f32


	PUBLIC	fam9511_f32
	EXTERN	cam32_sccz80_fam9511_f32

	defc	fam9511_f32 = cam32_sccz80_fam9511_f32


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fam9511_f32_fastcall
defc _fam9511_f32_fastcall = asm_am9511_f32
PUBLIC _fam9511_f32
EXTERN cam32_sdcc_fam9511_f32
defc _fam9511_f32 = cam32_sdcc_fam9511_f32
ENDIF

