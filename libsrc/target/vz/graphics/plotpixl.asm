
		SECTION	code_clib
		PUBLIC	plotpixel

		EXTERN	plot_MODE0
		EXTERN	plot_MODE1

		EXTERN	__vz200_mode



plotpixel:
		ld	a,(__vz200_mode)
		and	a
		jp	z,plot_MODE0
		jp	plot_MODE1
