
SECTION code_fp_math32
PUBLIC cm32_sdcc___fs2ulong_callee

EXTERN m32_f2ulong
EXTERN cm32_sdcc_fsreadl

cm32_sdcc___fs2ulong_callee:
	call	cm32_sdcc_fsreadl
	jp	m32_f2ulong
