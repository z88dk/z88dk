
    SECTION	code_clib
    PUBLIC	w_xorpixel

    EXTERN	xor_MODE0
    EXTERN	xor_MODE1

    EXTERN	__z9001_mode


w_xorpixel:
    ld	a,(__z9001_mode)
    cp	1
    jp	z,xor_MODE1
    and	a
    ret	nz
    jp	xor_MODE0
