
SECTION code_fp_math32
PUBLIC cm32_sdcc___fs2uint_callee

EXTERN m32_f2uint
EXTERN cm32_sdcc_fsreadl

cm32_sdcc___fs2uint_callee:
	call	cm32_sdcc_fsreadl
	jp	m32_f2uint
