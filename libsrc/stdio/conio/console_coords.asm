

		MODULE		console_coords
		SECTION		bss_clib
		PUBLIC		__console_x
		PUBLIC		__console_y

		PUBLIC		__console_w
		PUBLIC		__console_h
		PUBLIC		generic_console_caps

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
                EXTERN          CLIB_GENCON_CAPS

__console_x:	defb	0
__console_y:	defb	0


		SECTION		data_clib

__console_w:	defb	CONSOLE_COLUMNS
__console_h:	defb	CONSOLE_ROWS
generic_console_caps:
                defb    CLIB_GENCON_CAPS

