
SECTION code_fp_math32
PUBLIC cm32_sdcc___fs2slong

EXTERN m32_f2slong
EXTERN cm32_sdcc_fsread1

cm32_sdcc___fs2slong:
	call	cm32_sdcc_fsread1
	jp	m32_f2slong
