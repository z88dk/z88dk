
	SECTION		bss_clib

	PUBLIC		__x_proportional
	PUBLIC		__y_proportional
	PUBLIC		__xchar_proportional
	PUBLIC		__X_int1
	PUBLIC		__X_int2
	PUBLIC		__X_int3
	PUBLIC		__x_must_expose

__x_proportional:	defw	0
__y_proportional:	defw	0
__xchar_proportional:	defw	0
__X_int1:		defw	0
__X_int2:		defw	0
__X_int3:		defw	0
__x_must_expose:	defw	0

	SECTION		code_crt_init

	ld	a,1
	ld	(__x_must_expose),a

