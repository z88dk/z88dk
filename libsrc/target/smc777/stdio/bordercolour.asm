; void bordercolor(int c) __z88dk_fastcall;
;
;

		SECTION		code_clib
		PUBLIC		bordercolor
		PUBLIC		_bordercolor

		EXTERN		conio_map_colour

bordercolor:
_bordercolor:
	ld	a,l
	call	conio_map_colour
	jr	c,no_rotate
	rrca
	rrca
	rrca
	rrca
no_rotate:
	and	15
	out	($23),a
	ret
