
        MODULE  __scanf_handle_B
        SECTION code_clib
        PUBLIC  __scanf_handle_B
	PUBLIC  __scanf_b_fmt_entry_from_i

        EXTERN  __scanf_common_start
	EXTERN  __scanf_getchar
        EXTERN  scanf_exit
	EXTERN	asm_isbdigit
	EXTERN	__scanf_parse_number

__scanf_handle_B:
        call    __scanf_common_start
        jp      c,scanf_exit
        cp      '%'
        jr      nz,handle_b_fmt_nobase
__scanf_b_fmt_entry_from_i:
        call    __scanf_getchar
        jp      c,scanf_exit
handle_b_fmt_nobase:
        call    asm_isbdigit
        jp      c,scanf_exit
        ld      b,2
        jp      __scanf_parse_number
