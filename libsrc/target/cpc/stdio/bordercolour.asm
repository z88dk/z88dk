; void bordercolor(int c) __z88dk_fastcall;
;
;

		SECTION		code_clib
		PUBLIC		bordercolor
		PUBLIC		_bordercolor

		EXTERN		conio_map_colour_firmware
		EXTERN		cpc_SetBorder

bordercolor:
_bordercolor:
	ld	a,l
	call	conio_map_colour_firmware
	ld	l,a
	jp	cpc_SetBorder
