
    SECTION	code_clib
    PUBLIC	w_pointxy

    EXTERN	pointxy_MODE0
    EXTERN	pointxy_MODE1

    EXTERN	__z9001_mode


w_pointxy:
    ld	a,(__z9001_mode)
    cp	1	
    jp	z,pointxy_MODE1
    and	a
    ret	nz
    jp	pointxy_MODE0
