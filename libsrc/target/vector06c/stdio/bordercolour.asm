; void bordercolor(int c) __z88dk_fastcall;
;
;

		SECTION		code_clib
		PUBLIC		bordercolor
		PUBLIC		_bordercolor

		EXTERN		__vector06c_mode

bordercolor:
_bordercolor:
	ld	a,(__vector06c_mode)
	or	l
	out	($02),a
	ret
