
	MODULE	__scanf_parse_number
	SECTION code_clib
	PUBLIC  __scanf_parse_number

	EXTERN	__scanf_ungetchar
	EXTERN  __scanf_get_number
	EXTERN  scanf_loop

; Entry:
;	a = first character of number
;      hl = format string
;      ix = scanf frame
__scanf_parse_number:
        call    __scanf_ungetchar
        call    __scanf_get_number
        jp      scanf_loop
