

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse
		PUBLIC		generic_console_pointxy

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		asm_toupper

		defc		DISPLAY = 0xf3c8

generic_console_ioctl:
	scf
generic_console_set_paper:
generic_console_set_inverse:
generic_console_set_ink:
	ret

	

generic_console_cls:
	ld	hl, DISPLAY
	ld	de,120
	ld	c,25
cls_1:
	push	hl
	ld	b,80
cls_2:
	ld	(hl),' '
	inc	hl
	djnz	cls_2
	ld	b,40
cls_3:
	ld	(hl),0
	inc	hl
	djnz	cls_3
	pop	hl
	add	hl,de
	dec	c
	jr	nz,cls_1
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	push	de
	call	xypos
	pop	de
	ld	(hl),a
	ret


generic_console_pointxy:
	call	generic_console_vpeek
	and	a
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        call    xypos
	ld	a,(hl)
	and	a
	ret


xypos:
	ld	hl,DISPLAY - 120
	ld	de,120
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
	ld	hl, DISPLAY + 120
	ld	de, DISPLAY
	ld	bc, 120 * 24
	ldir
	ex	de,hl
	ld	b,80
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	ld	b,40
scroll_2:
	ld	(hl),0
	inc	hl
	djnz	scroll_2
	pop	bc
	pop	de
	ret
