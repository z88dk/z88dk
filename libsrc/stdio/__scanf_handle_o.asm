
        MODULE  __scanf_handle_o
        SECTION code_clib
        PUBLIC  __scanf_handle_o
	PUBLIC  __scanf_o_fmt_entry_from_i

        EXTERN  __scanf_common_start
        EXTERN  scanf_exit
	EXTERN	asm_isodigit
	EXTERN	__scanf_parse_number

__scanf_handle_o:
        call    __scanf_common_start    ;de=argument
        jp      c,scanf_exit
__scanf_o_fmt_entry_from_i:
        call    asm_isodigit            ;is it actually octal?
        jp      c,scanf_exit
        ld      b,8
        jp      __scanf_parse_number
