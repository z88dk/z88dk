
SECTION code_fp_math32
PUBLIC cm32_sdcc___fs2ulong

EXTERN m32_f2ulong
EXTERN cm32_sdcc_fsread1

cm32_sdcc___fs2ulong:
	call	cm32_sdcc_fsread1
	jp	m32_f2ulong
