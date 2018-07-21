
		SECTION	code_clib
		PUBLIC	pointxy

		EXTERN	pointxy_MODE0
		EXTERN	pointxy_MODE1
		EXTERN	pointxy_MODE2

		EXTERN	__pc6001_mode
		INCLUDE	"target/pc6001/def/pc6001.def"


pointxy:
		ld	a,(__pc6001_mode)
		cp	MODE_1
		jp	z,pointxy_MODE1
		cp	MODE_2
		jp	z,pointxy_MODE2
		and	a
		ret	nz
		jp	pointxy_MODE0
