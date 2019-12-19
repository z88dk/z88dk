
		SECTION	code_clib
		PUBLIC	respixel

		EXTERN	res_MODE0
		EXTERN	res_MODE1

		EXTERN	__vz200_mode


respixel:
		ld	a,(__vz200_mode)
		and	a
		jp	z,res_MODE0
		jp	res_MODE1
