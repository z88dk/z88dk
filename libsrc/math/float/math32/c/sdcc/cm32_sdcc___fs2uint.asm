
SECTION code_fp_math32
PUBLIC cm32_sdcc___fs2uint
PUBLIC cm32_sdcc___fs2uchar

EXTERN m32_f2uint
EXTERN cm32_sdcc_fsread1

cm32_sdcc___fs2uint:
cm32_sdcc___fs2uchar:
	call	cm32_sdcc_fsread1
	jp	m32_f2uint
