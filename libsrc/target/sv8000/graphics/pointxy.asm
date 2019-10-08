
		SECTION	code_clib
		PUBLIC	pointxy

		EXTERN	pointxy_MODE0
		EXTERN	pointxy_MODE1

		EXTERN	__sv8000_mode
		INCLUDE	"target/sv8000/def/sv8000.def"


pointxy:
		ld	a,(__sv8000_mode)
		cp	MODE_1
		jp	z,pointxy_MODE1
		and	a
		ret	nz
		jp	pointxy_MODE0
