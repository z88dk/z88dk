
		SECTION	code_clib
		PUBLIC	plotpixel

		EXTERN	plot_MODE0
		EXTERN	plot_MODE1
		EXTERN	plot_MODE2

		EXTERN	__spc1000_mode

		INCLUDE	"target/spc1000/def/spc1000.def"


plotpixel:
		ld	a,(__spc1000_mode)
		cp	1
		jp	z,plot_MODE1
		cp	2
		jp	z,plot_MODE2
		and	a
		ret	nz
		jp	plot_MODE0
