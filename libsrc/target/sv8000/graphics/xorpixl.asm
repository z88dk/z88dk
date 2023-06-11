
		SECTION	code_clib
		PUBLIC	xorpixel

		EXTERN	xor_MODE0
		EXTERN	xor_MODE1

		EXTERN	__sv8000_mode
		INCLUDE	"target/sv8000/def/sv8000.def"


xorpixel:
		ld	a,(__sv8000_mode)
		cp	MODE_1
		jp	z,xor_MODE1
		and	a
		ret	nz
		jp	xor_MODE0
