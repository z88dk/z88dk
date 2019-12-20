
		SECTION	code_clib
		PUBLIC	plotpixel

		EXTERN	plot_MODE0
		EXTERN	plot_MODE1

		EXTERN	__sv8000_mode

		INCLUDE	"target/sv8000/def/sv8000.def"


plotpixel:
		ld	a,(__sv8000_mode)
		cp	MODE_1
		jp	z,plot_MODE1
		and	a
		ret	nz
		jp	plot_MODE0
