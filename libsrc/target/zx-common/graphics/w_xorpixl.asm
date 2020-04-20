;
;       Plot pixel at (x,y) coordinate.



        SECTION code_clib
        PUBLIC  w_xorpixel
	EXTERN	xor_MODE0
	EXTERN	xor_MODE6
	EXTERN	xor_MODE64

	EXTERN	__zx_screenmode
        defc    NEEDxor = 1


.w_xorpixel
	ld	a,(__zx_screenmode)
	cp	3
	jp	c,xor_MODE0
IF FORzxn
	bit	6,a
	jp	nz,xor_MODE64
ENDIF
	jp	xor_MODE6



