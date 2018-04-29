

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		asctozx81_entry_reg

		defc		D_FILE = 16396

generic_console_ioctl:
	scf
generic_console_set_ink:
generic_console_set_paper:
generic_console_set_inverse:
	ret

generic_console_cls:
	ld	hl,(D_FILE)
	inc	hl
	ld	c,CONSOLE_ROWS
generic_console_cls_1:
	ld	b,CONSOLE_COLUMNS
generic_console_cls_2:
	ld	(hl),0
	inc	hl
	djnz	generic_console_cls_2
	ld	(hl),0x76
	inc	hl
	dec	c
	jr	nz,generic_console_cls_1
	ret



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


generic_console_scrollup:
	push	de
	push	bc
	ld	hl,(D_FILE)
	inc	hl
	ld	d,h
	ld	e,l
	ld	bc,CONSOLE_COLUMNS + 1
	add	hl,bc
	ld	bc,+ ((CONSOLE_COLUMNS+1) * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
generic_console_scrollup_3:
	ld	(hl),0
	inc	hl
	djnz	generic_console_scrollup_3
	ld	(hl),0x76
	pop	bc
	pop	de
	ret
