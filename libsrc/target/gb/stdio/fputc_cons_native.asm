
	SECTION	code_driver

	PUBLIC	fputc_cons_native
	PUBLIC	_fputc_cons_native
	PUBLIC	getk
	PUBLIC	_getk


fputc_cons_native:
_fputc_cons_native:
	GLOBAL	_putchar
	jp	_putchar

getk:
_getk:
	ret
