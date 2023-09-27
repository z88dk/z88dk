

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		asctozx81_entry_reg
		EXTERN		zx81toasc

		defc		D_FILE = 16396

		PUBLIC          CLIB_GENCON_CAPS
		defc            CLIB_GENCON_CAPS = 0


generic_console_ioctl:
	scf
generic_console_set_ink:
generic_console_set_paper:
generic_console_set_attribute:
	ret

generic_console_cls:
IF FORlambda
	ld	hl,16510
ELSE
	ld	hl,(D_FILE)
	inc	hl
ENDIF
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
	call	xypos
	pop	de
	rr	e
	call	nc,asctozx81_entry_reg
	ld	(hl),a
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	push	de
        call    xypos
	pop	de
        ld      a,(hl)
	rl	e
	call	nc,zx81toasc	;reloads from (hl) but nevermind
        and     a
        ret

xypos:
IF FORlambda
	ld	hl,16510
ELSE
	ld	hl,(D_FILE)
	inc	hl
ENDIF
	ld	de,CONSOLE_COLUMNS+1
	and	a
	sbc	hl,de
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	ret


generic_console_scrollup:
	push	de
	push	bc
IF FORlambda
	ld	hl,16510
ELSE
	ld	hl,(D_FILE)
	inc	hl
ENDIF
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
