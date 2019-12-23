

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
		
		defc		DISPLAY = $e800

		INCLUDE	"ioctl.def"
		PUBLIC  CLIB_GENCON_CAPS
		defc    CLIB_GENCON_CAPS = CAP_GENCON_INVERSE


generic_console_ioctl:
	scf
generic_console_set_ink:
generic_console_set_paper:
generic_console_set_attribute:
	ret

generic_console_cls:
	ld	hl,DISPLAY
	ld	de,DISPLAY+1
	ld	bc,+(CONSOLE_COLUMNS * CONSOLE_ROWS) -1
	ld	(hl),32
	ldir
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
	ld	a,(generic_console_flags)
	and	128
	or	d
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
	and	127
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
	ld	hl, DISPLAY + CONSOLE_COLUMNS
	ld	de, DISPLAY
	ld	bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	pop	bc
	pop	de
	ret
