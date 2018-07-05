; 
; Variables that point to the font and udgs used by gencon
;

		SECTION		data_clib

		PUBLIC		generic_console_font32
		PUBLIC		generic_console_udg32

		EXTERN		CRT_FONT


generic_console_font32:	defw	CRT_FONT
generic_console_udg32:	defw	0

