
	SECTION	code_fp_math32

	PUBLIC	f32_fam9511_fastcall
	EXTERN	m32_f32_fam9511

	defc	f32_fam9511_fastcall = m32_f32_fam9511


	PUBLIC	f32_fam9511
	EXTERN	cm32_sccz80_f32_fam9511

	defc	f32_fam9511 = cm32_sccz80_f32_fam9511


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _f32_fam9511_fastcall
defc _f32_fam9511_fastcall = m32_f32_fam9511
PUBLIC _f32_fam9511
EXTERN cm32_sdcc_f32_fam9511
defc _f32_fam9511 = cm32_sdcc_f32_fam9511
ENDIF

	PUBLIC	fam9511_f32_fastcall
	EXTERN	m32_fam9511_f32

	defc	fam9511_f32_fastcall = m32_fam9511_f32


	PUBLIC	fam9511_f32
	EXTERN	cm32_sccz80_fam9511_f32

	defc	fam9511_f32 = cm32_sccz80_fam9511_f32


; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _fam9511_f32_fastcall
defc _fam9511_f32_fastcall = m32_fam9511_f32
PUBLIC _fam9511_f32
EXTERN cm32_sdcc_fam9511_f32
defc _fam9511_f32 = cm32_sdcc_fam9511_f32
ENDIF

