
		SECTION	code_clib
		PUBLIC	xorpixl

		EXTERN	xor_MODE0
		EXTERN	xor_MODE1

		EXTERN	__vz200_mode


xorpixl:
		ld	a,(__vz200_mode)
		and	a
		jp	z,xor_MODE0
		jp	xor_MODE1
