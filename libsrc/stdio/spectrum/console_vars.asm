
		MODULE		console_vars

		PUBLIC		__ts2068_hrgmode
		PUBLIC		__zx_console_attr
		PUBLIC		__zx_32col_font
		PUBLIC		__zx_32col_udgs
		PUBLIC		__zx_64col_font

		EXTERN		CRT_FONT
		EXTERN		CRT_FONT_64


		SECTION		data_clib

__zx_console_attr:	defb	56		;Default attribute
__zx_32col_font:	defw	CRT_FONT
__zx_64col_font:	defw	CRT_FONT_64
__zx_32col_udgs:	defw	65368

		SECTION		bss_clib

__ts2068_hrgmode:	defb	0		;If set TS2068 hrgmode is active


