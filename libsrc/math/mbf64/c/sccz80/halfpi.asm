	SECTION	code_fp_mbf64
	PUBLIC	halfpi

	EXTERN	___mbf64_FA


halfpi:
	ld	hl,halfpi_value
	ld	de,___mbf64_FA
	ld	bc,8
	ldir
	ret

	SECTION	rodata_fp_mbf64

halfpi_value:
	defb    0xc0,0x68,0x21,0xa2,0xda,0x0f,0x49,0x81
