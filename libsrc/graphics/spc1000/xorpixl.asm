
		SECTION	code_clib
		PUBLIC	xorpixl

		EXTERN	xor_MODE0
		EXTERN	xor_MODE1
		EXTERN	xor_MODE2
                EXTERN  __tms9918_xorpixl

		EXTERN	__spc1000_mode
		INCLUDE	"target/spc1000/def/spc1000.def"


xorpixl:
		ld	a,(__spc1000_mode)
		cp	1
		jp	z,xor_MODE1
		cp	2
		jp	z,xor_MODE2
                cp      10
                jp      nc,__tms9918_xorpixl
		and	a
		ret	nz
		jp	xor_MODE0
