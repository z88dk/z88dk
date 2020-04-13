;
;       Plot pixel at (x,y) coordinate.



        SECTION code_clib
        PUBLIC  w_plotpixel


	EXTERN	plot_MODE0
	EXTERN	plot_MODE6
	EXTERN	plot_MODE64
	EXTERN	__zx_screenmode
        defc    NEEDplot = 1


.w_plotpixel
	ld	a,(__zx_screenmode)
	cp	3
	jp	c,plot_MODE0
IF FORzxn
	bit	6,a
	jp	nz,plot_MODE64
ENDIF
	jp	plot_MODE6



