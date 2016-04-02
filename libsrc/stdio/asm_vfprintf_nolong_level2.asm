

		PUBLIC	asm_vfprintf_nolong_level2


		SECTION	code_clib

asm_vfprintf_nolong_level2:
		defc   printflevel = 2
		INCLUDE "stdio/asm_printf_core.asm"
