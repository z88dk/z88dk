

		SECTION		bss_clib

		PUBLIC		__gemini_mode
		PUBLIC		__gemini_custom_font


__gemini_mode:	defb		0
		; Mode 1 = 80 column 
		; Mode 2 = 40 column 
		; Mode 4 = 32 column. HR graphics

__gemini_custom_font:
		defb		0

		SECTION         data_clib
		PUBLIC		__gemini_attr

__gemini_attr:     defb            0xf
