
		SECTION	code_clib
		PUBLIC	xorpixel

		EXTERN	xor_MODE0
		EXTERN	xor_MODE1
		EXTERN	xor_MODE2

		EXTERN	__pc6001_mode
		INCLUDE	"target/pc6001/def/pc6001.def"


xorpixel:
		ld	a,(__pc6001_mode)
		cp	MODE_1
		jp	z,xor_MODE1
		cp	MODE_2
		jp	z,xor_MODE2
		and	a
		ret	nz
		jp	xor_MODE0
