
		SECTION	code_clib
		PUBLIC	respixel

		EXTERN	res_MODE0
		EXTERN	res_MODE1

		EXTERN	__z1013_mode

respixel:
		ld	a,(__z1013_mode)
		cp	1
		jp	z,res_MODE1
		and	a
		ret	nz
		jp	res_MODE0
