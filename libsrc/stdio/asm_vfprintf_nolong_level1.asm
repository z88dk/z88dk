

		PUBLIC	asm_vfprintf_nolong_level1


		SECTION	code_clib

asm_vfprintf_nolong_level1:
		defc   printflevel = 1
		INCLUDE "stdio/asm_printf_core.asm"
