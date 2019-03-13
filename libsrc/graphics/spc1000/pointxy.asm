
		SECTION	code_clib
		PUBLIC	pointxy

		EXTERN	pointxy_MODE0
		EXTERN	pointxy_MODE1
		EXTERN	pointxy_MODE2
                EXTERN  __tms9918_pointxy

		EXTERN	__spc1000_mode
		INCLUDE	"target/spc1000/def/spc1000.def"


pointxy:
		ld	a,(__spc1000_mode)
		cp	1	
		jp	z,pointxy_MODE1
		cp	2
		jp	z,pointxy_MODE2
                cp      10
                jp      nc,__tms9918_pointxy
		and	a
		ret	nz
		jp	pointxy_MODE0
