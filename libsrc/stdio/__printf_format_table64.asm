; Default set of formatters for printf
;
; These will be used by default when sdcc pulls in printf

	MODULE	__printf_format_table64
	SECTION data_clib
	PUBLIC	__printf_format_table64
	EXTERN	__printf_handle_lld
	EXTERN	__printf_handle_llu
	EXTERN	__printf_handle_llx
	EXTERN	__printf_handle_llo
	EXTERN	__printf_handle_llX
	EXTERN	__printf_handle_llB


__printf_format_table64:
	defb	'd'
	defw	__printf_handle_lld
	defb	'u'
	defw	__printf_handle_llu
	defb	'x'
	defw	__printf_handle_llx
	defb	'o'
	defw	__printf_handle_llo
	defb	'X'
	defw	__printf_handle_llX
	defb	'B'
	defw	__printf_handle_llB
	defb	0
