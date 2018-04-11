

		SECTION		code_clib

		PUBLIC		generic_console_printc

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		asctozx81_entry_reg

		defc		D_FILE = 16396

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	push	de		;save raw
	ld	hl,(D_FILE)
	inc	hl
	ld	de,CONSOLE_COLUMNS+1
	and	a
	sbc	hl,de
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	pop	de
	rl	e
	call	nc,asctozx81_entry_reg
	ld	(hl),a
	ret
