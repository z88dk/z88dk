; void bordercolor(int c) __z88dk_fastcall;
;
;

		SECTION		code_clib
		PUBLIC		bordercolor
		PUBLIC		_bordercolor

		EXTERN		conio_map_colour
		EXTERN		cpc_SetBorder

bordercolor:
_bordercolor:
	ld	a,l
	ld	hl,12288
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,39
	ld	(hl),' '
	ldir
	ld	hl,12288 + 1024
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,39
	ld	(hl),a
	ldir
	ret
