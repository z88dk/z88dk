
SECTION code_fp_math32
PUBLIC cm32_sdcc___fs2slong_callee

EXTERN m32_f2slong
EXTERN cm32_sdcc_fsread1_callee

cm32_sdcc___fs2slong_callee:
	call	cm32_sdcc_fsread1_callee
	jp	m32_f2slong
