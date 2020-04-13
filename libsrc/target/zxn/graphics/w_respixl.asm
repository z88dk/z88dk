;
;       Plot pixel at (x,y) coordinate.



        SECTION code_clib
        PUBLIC  w_respixel
	EXTERN	res_MODE0
	EXTERN	res_MODE6
	EXTERN	res_MODE64

	EXTERN	__zx_screenmode
        defc    NEEDres = 1


.w_respixel
	ld	a,(__zx_screenmode)
	cp	3
	jp	c,res_MODE0
	bit	6,a
	jp	nz,res_MODE64
	jp	res_MODE6



