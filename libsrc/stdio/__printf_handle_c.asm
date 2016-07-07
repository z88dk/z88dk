
	MODULE	__printf_handle_c
	SECTION	code_clib
	PUBLIC	__printf_handle_c

	EXTERN	get_16bit_ap_parameter
	EXTERN	__printf_print_to_buf
	EXTERN	__printf_print_the_buffer


__printf_handle_c:
	push    hl              ; Save format
        call    get_16bit_ap_parameter  ;de=new ap, hl=character to print
        push    de
        ld      a,l
        call    __printf_print_to_buf
	jp	__printf_print_the_buffer
