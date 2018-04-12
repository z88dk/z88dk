

		SECTION		code_clib

		PUBLIC		generic_console_printc

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		asctozx81_entry_reg

		defc		DISPLAY = 0x7000

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	ld	hl,DISPLAY - CONSOLE_COLUMNS
	ld	de,CONSOLE_COLUMNS
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	rr	e
	call	nc,convert_character
	ld	(hl),a
	ret

convert_character:
        cp      97
        jr      c,isupper
        sub     32
.isupper
        and     @00111111
	ret
