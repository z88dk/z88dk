;
; Default format table for scanf family
	MODULE  __scanf_format_table
	SECTION	data_clib
	PUBLIC	__scanf_format_table

	EXTERN	__scanf_handle_d
	EXTERN	__scanf_handle_s
	EXTERN	__scanf_handle_c
	EXTERN	__scanf_handle_x
	EXTERN	__scanf_handle_o
	EXTERN	__scanf_handle_B
	EXTERN	__scanf_handle_i

__scanf_format_table:
	defb	'd'
	defw	__scanf_handle_d
	defb	's'
	defw	__scanf_handle_s
	defb	'c'
	defw	__scanf_handle_c
	defb	'u'
	defw	__scanf_handle_d
	defb	'x'
	defw	__scanf_handle_x
	defb	'o'
	defw	__scanf_handle_o
	defb	'B'
	defw	__scanf_handle_B
	defb	'i'
	defw	__scanf_handle_i
	defb	0
