
		SECTION	code_clib
		PUBLIC	xorpixel

		EXTERN	xor_MODE0
		EXTERN	xor_MODE1

		EXTERN	__vz200_mode


xorpixel:
		ld	a,(__vz200_mode)
		and	a
		jp	z,xor_MODE0
		jp	xor_MODE1
