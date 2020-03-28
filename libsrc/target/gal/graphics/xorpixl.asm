
		SECTION	code_clib
		PUBLIC	xorpixl

		EXTERN	xor_MODE0
		EXTERN	xor_MODE1

		EXTERN	__gal_mode


xorpixl:
		ld	a,(__gal_mode)
		cp	1
		jp	z,xor_MODE1
		and	a
		ret	nz
		jp	xor_MODE0
