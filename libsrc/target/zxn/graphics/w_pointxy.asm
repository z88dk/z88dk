;
;       Plot pixel at (x,y) coordinate.



        SECTION code_clib
        PUBLIC  w_pointxy
	EXTERN	pointxy_MODE0
	EXTERN	pointxy_MODE6
	EXTERN	pointxy_MODE64

	EXTERN	__zx_screenmode
        defc    NEEDpointxy = 1


.w_pointxy
	ld	a,(__zx_screenmode)
	cp	3
	jp	c,pointxy_MODE0
IF FORzxn
	bit	6,a
	jp	nz,pointxy_MODE64
ENDIF
	jp	pointxy_MODE6



