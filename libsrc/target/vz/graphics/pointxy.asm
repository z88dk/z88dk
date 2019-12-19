
		SECTION	code_clib
		PUBLIC	pointxy

		EXTERN	pointxy_MODE0
		EXTERN	pointxy_MODE1

		EXTERN	__vz200_mode


pointxy:
		ld	a,(__vz200_mode)
		and	a
		jp	z,pointxy_MODE0
		jp	pointxy_MODE1
