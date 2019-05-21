
SECTION code_fp_math32
PUBLIC cm32_sdcc___fs2sint
PUBLIC cm32_sdcc___fs2schar

EXTERN m32_f2sint
EXTERN cm32_sdcc_fsreadl

cm32_sdcc___fs2sint:
cm32_sdcc___fs2schar:
	call	cm32_sdcc_fsreadl
	jp	m32_f2sint
