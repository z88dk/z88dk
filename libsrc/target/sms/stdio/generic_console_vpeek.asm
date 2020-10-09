
	SECTION code_clib

	PUBLIC	generic_console_vpeek
	EXTERN	__tms9918_console_vpeek

	defc generic_console_vpeek = __tms9918_console_vpeek
