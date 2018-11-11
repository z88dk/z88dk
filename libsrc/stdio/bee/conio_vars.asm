

		SECTION		bss_clib

		PUBLIC		__bee_mode
		PUBLIC		__bee_custom_font


__bee_mode:	defb		0
		; Mode 0 = 80 column 
		; Mode 1 = 64 column 
		; Mode 2 = 40 column

__bee_custom_font:
		defb		0

		SECTION         data_clib
		PUBLIC		__bee_attr

__bee_attr:     defb            0xf
