

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute
                PUBLIC          generic_console_plotc
                PUBLIC          generic_console_pointxy
                EXTERN		generic_console_flags

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		asm_toupper
		
		defc		ATTRS = $e000
		defc		DISPLAY = $e800

		INCLUDE	"ioctl.def"
	        PUBLIC  CLIB_GENCON_CAPS
		defc	CLIB_GENCON_CAPS = 0

generic_console_ioctl:
	scf
generic_console_set_ink:
generic_console_set_paper:
generic_console_set_attribute:
	ret

generic_console_cls:
	ld	bc,+(CONSOLE_COLUMNS * CONSOLE_ROWS) 
	ld	hl,DISPLAY
	ld	de,ATTRS
cls_1:
	ld	(hl),' '
	inc	hl
	xor	a
	ld	(de),a
	inc	de
	dec	bc
	ld	a,b
	or	c
	jr	nz,cls_1
	ret


; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_plotc:
	call	xypos
	ld	(hl),d
	ret

generic_console_printc:
	call	xypos
	ld	a,e
	rrca
	ld	a,d
	call	nc,asm_toupper
	ld	(hl),a
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_pointxy:
        call    xypos
	ld	a,(hl)
	and	a
	ret

generic_console_vpeek:
        call    xypos
	ld	a,(hl)
	ret


; b = row
; c = column
xypos:
	ld	l,b
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld	b,+(DISPLAY / 256)
	add	hl,bc
	ret


generic_console_scrollup:
	push	de
	push	bc
	; TODO: ATTRS
	ld	bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
	ld	hl, DISPLAY + CONSOLE_COLUMNS
	ld	de, DISPLAY
scrollup_1:
	ld	a,(hl)
	ld	(de),a
	inc	hl
	inc	de
	dec	bc
	ld	a,b
	or	c
	jr	nz,scrollup_1
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	pop	bc
	pop	de
	ret
