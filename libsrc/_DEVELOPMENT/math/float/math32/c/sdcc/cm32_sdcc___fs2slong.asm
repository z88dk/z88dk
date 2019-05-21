
SECTION code_fp_math32
PUBLIC cm32_sdcc___fs2slong

EXTERN m32_f2slong
EXTERN cm32_sdcc_fsreadl

cm32_sdcc___fs2slong:
	call	cm32_sdcc_fsreadl
	jp	m32_f2slong
