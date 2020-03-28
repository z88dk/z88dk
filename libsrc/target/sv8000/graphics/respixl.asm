
		SECTION	code_clib
		PUBLIC	respixel

		EXTERN	res_MODE0
		EXTERN	res_MODE1

		EXTERN	__sv8000_mode
		INCLUDE	"target/sv8000/def/sv8000.def"


respixel:
		ld	a,(__sv8000_mode)
		cp	MODE_1
		jp	z,res_MODE1
		and	a
		ret	nz
		jp	res_MODE0
