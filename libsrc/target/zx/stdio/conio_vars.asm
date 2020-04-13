
		MODULE		console_vars

		PUBLIC		__zx_console_attr

		SECTION		data_clib

__zx_console_attr:	defb	56		;Default attribute
IF FORzxn
		PUBLIC	__zx_ink_colour
__zx_ink_colour:	defb	15		;Default ink colour
ENDIF

