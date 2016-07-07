
	MODULE	__printf_handle_n
	SECTION code_clib
	PUBLIC	__printf_handle_n
	EXTERN	__printf_loop
	EXTERN	get_16bit_ap_parameter


__printf_handle_n:
        push    hl              ;save format
        call    get_16bit_ap_parameter  ; de = ap, hl = value
        ld      a,(ix-2)
        ld      (hl),a
        ld      a,(ix-1)
        inc     hl
        ld      (hl),a
        pop     hl
        jp      __printf_loop
