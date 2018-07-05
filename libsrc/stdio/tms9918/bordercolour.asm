; void bordercolor(int c) __z88dk_fastcall;
;
;

		SECTION		code_clib

IF FORspc1000
		PUBLIC		__tms9918_bordercolor
ELSE
		PUBLIC		bordercolor
		PUBLIC		_bordercolor

		defc	bordercolor = __tms9918_bordercolor
		defc	_bordercolor = __tms9918_bordercolor
ENDIF
		EXTERN		conio_map_colour
		EXTERN		msx_set_border

__tms9918_bordercolor:
	ld	a,l
	call	conio_map_colour
	ld	l,a
	jp	msx_set_border
