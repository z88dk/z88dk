
	MODULE	__printf_handle_ll
	SECTION code_clib
	PUBLIC	__printf_handle_ll
	EXTERN	__printf_format_table64
	EXTERN	__printf_format_search_loop

; Entry:  hl = fmt
;	  de = ap
;	  ix = printf context
__printf_handle_ll:
	ld	c,(hl)	; next bit of format
	inc	hl
	push	hl	;save next format
	ld	hl,__printf_format_table64
	jp	__printf_format_search_loop
