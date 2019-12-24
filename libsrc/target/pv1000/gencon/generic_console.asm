;
;
; VideoRAM = b800 -> baff	-> 768 locations geom: 32 x 24
; gfxram   = bc00 -> bfff	-> 8 bytes unused, 8 bytes r, 8 bytes g, 8 bytes b


		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		defc		DISPLAY = 0xb800

		PUBLIC  CLIB_GENCON_CAPS
        	defc    CLIB_GENCON_CAPS = 0

generic_console_ioctl:
	scf
generic_console_set_attribute:
	ret

generic_console_set_ink:
	ret

	
generic_console_set_paper:
	ret

generic_console_cls:
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc, +(32 * CONSOLE_ROWS) - 1
	ld	(hl),32
	ldir
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	call	xypos
	ld	(hl),a
	ret


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        call    xypos
        ld      a,(hl)
        and     a
        ret


xypos:
	ld	hl,DISPLAY - 30		; We lose left most two columns
	ld	de,32
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
	ld	hl, DISPLAY + 32
	ld	de, DISPLAY
	ld	bc,+ ((32) * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,32
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	pop	bc
	pop	de
	ret
