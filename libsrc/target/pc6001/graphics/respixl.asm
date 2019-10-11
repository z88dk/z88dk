
		SECTION	code_clib
		PUBLIC	respixel

		EXTERN	res_MODE0
		EXTERN	res_MODE1
		EXTERN	res_MODE2

		EXTERN	__pc6001_mode
		INCLUDE	"target/pc6001/def/pc6001.def"


respixel:
		ld	a,(__pc6001_mode)
		cp	MODE_1
		jp	z,res_MODE1
		cp	MODE_2
		jp	z,res_MODE2
		and	a
		ret	nz
		jp	res_MODE0
