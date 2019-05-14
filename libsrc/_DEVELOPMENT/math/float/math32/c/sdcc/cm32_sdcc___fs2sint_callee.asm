
SECTION code_fp_math32
PUBLIC cm32_sdcc___fs2sint_callee

EXTERN m32_f2sint
EXTERN cm32_sdcc_fsreadl

cm32_sdcc___fs2sint_callee:
	call	cm32_sdcc_fsreadl
	jp	m32_f2sint
