
		SECTION	code_clib
		PUBLIC	plotpixel

		EXTERN	plot_MODE0
		EXTERN	plot_MODE1
		EXTERN	plot_MODE2

               ; EXTERN  __gfx_coords
		EXTERN	__pc6001_mode

		INCLUDE	"target/pc6001/def/pc6001.def"


plotpixel:
               ; ld	(__gfx_coords),hl
		ld	a,(__pc6001_mode)
		cp	MODE_1
		jp	z,plot_MODE1
		cp	MODE_2
		jp	z,plot_MODE2
		and	a
		ret	nz
		jp	plot_MODE0
