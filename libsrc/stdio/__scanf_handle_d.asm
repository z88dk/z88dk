
        MODULE  __scanf_handle_d
        SECTION code_clib
        PUBLIC  __scanf_handle_d
        PUBLIC  __scanf_handle_u
	PUBLIC  __scanf_d_fmt_entry_from_i

        EXTERN  __scanf_common_start
        EXTERN  scanf_exit
	EXTERN	asm_isdigit
	EXTERN	__scanf_parse_number

__scanf_handle_d:
__scanf_handle_u:
        call    __scanf_common_start    ;de=argument as necessary
        jp      c,scanf_exit
__scanf_d_fmt_entry_from_i:
        call    asm_isdigit
        jp      c,scanf_exit
        ; So there's a decimal number on the stream
        ld      b,10                    ;radix
        jp      __scanf_parse_number
