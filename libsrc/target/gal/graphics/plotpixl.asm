
		SECTION	code_clib
		PUBLIC	plotpixel

		EXTERN	plot_MODE0
		EXTERN	plot_MODE1

		EXTERN	__gal_mode


plotpixel:
		ld	a,(__gal_mode)
		cp	1
		jp	z,plot_MODE1
		and	a
		ret	nz
		jp	plot_MODE0
