
		SECTION	code_clib
		PUBLIC	w_respixel

		EXTERN	res_MODE0
		EXTERN	res_MODE1

		EXTERN	__z9001_mode

w_respixel:
		ld	a,(__z9001_mode)
		cp	1
		jp	z,res_MODE1
		and	a
		ret	nz
		jp	res_MODE0
