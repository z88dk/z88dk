		MODULE		console_coords
		SECTION		bss_clib
		PUBLIC		__console_x
		PUBLIC		__console_y

		PUBLIC		__console_w
		PUBLIC		__console_h

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

        INCLUDE     "../ansi/ticalc.inc"

defc __console_x = ti_x_text
defc __console_y = ti_y_text

		SECTION		data_clib

__console_w:	defb	CONSOLE_COLUMNS
__console_h:	defb	CONSOLE_ROWS
