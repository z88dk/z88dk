

		PUBLIC	asm_vfprintf_nolong_level3


		SECTION	code_clib

asm_vfprintf_nolong_level3:
		defc   printflevel = 3
		INCLUDE "stdio/asm_printf_core.asm"
