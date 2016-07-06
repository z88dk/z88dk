
        MODULE  __scanf_handle_i
        SECTION code_clib
        PUBLIC  __scanf_handle_i

        EXTERN  __scanf_common_start
	EXTERN  __scanf_getchar
        EXTERN  scanf_exit
	EXTERN	asm_isodigit
	EXTERN	__scanf_parse_number

	EXTERN	__scanf_b_fmt_entry_from_i
	EXTERN	__scanf_d_fmt_entry_from_i
	EXTERN	__scanf_o_fmt_entry_from_i
	EXTERN	__scanf_x_fmt_leader_found
	EXTERN  __scanf_x_only_0_on_stream

__scanf_handle_i:
        call    __scanf_common_start
        jp      c,scanf_exit
        ; Determine the radix if we can
        cp      '0'
        jr      z,handle_i_fmt_octalorhex
        cp      '%'
        jp      z,__scanf_b_fmt_entry_from_i
        ; It must be decimal
        jp      __scanf_d_fmt_entry_from_i
handle_i_fmt_octalorhex:
        call    __scanf_getchar
        jp      c,__scanf_x_only_0_on_stream
        cp      'x'
        jp      z,__scanf_x_fmt_leader_found
        cp      'X'
        jp      z,__scanf_x_fmt_leader_found
        ; Must be octal then
        jp      __scanf_o_fmt_entry_from_i
