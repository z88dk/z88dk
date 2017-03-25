; Default set of formatters for printf
;
; These will be used by default when sdcc pulls in printf

	MODULE	__printf_format_table
	SECTION data_clib
	PUBLIC	__printf_format_table
	PUBLIC	__printf_get_flags

	EXTERN	__printf_get_flags_impl
	EXTERN	__printf_handle_s
	EXTERN	__printf_handle_c
	EXTERN	__printf_handle_d
	EXTERN	__printf_handle_u
	EXTERN	__printf_handle_x
	EXTERN	__printf_handle_o
	EXTERN	__printf_handle_p
	EXTERN	__printf_handle_X
	EXTERN	__printf_handle_B
	EXTERN	__printf_handle_n
	EXTERN	__printf_handle_ll

	defc __printf_get_flags = __printf_get_flags_impl

__printf_format_table:
	defb	's'
	defw	__printf_handle_s
	defb	'c'
	defw	__printf_handle_c
	defb	'd'
	defw	__printf_handle_d
	defb	'u'
	defw	__printf_handle_u
	defb	'x'
	defw	__printf_handle_x
	defb	'o'
	defw	__printf_handle_o
	defb	'p'
	defw	__printf_handle_p
	defb	'X'
	defw	__printf_handle_X
	defb	'n'
	defw	__printf_handle_n
	defb	'B'
	defw	__printf_handle_B
	defb	'l'
	defw	__printf_handle_ll
	defb	0
