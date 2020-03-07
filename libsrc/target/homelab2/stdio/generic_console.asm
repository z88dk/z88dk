

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute
                EXTERN		generic_console_flags

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		CONSOLE_DISPLAY		
		
		EXTERN		asm_toupper

		INCLUDE	"ioctl.def"
	        PUBLIC  CLIB_GENCON_CAPS
		defc	CLIB_GENCON_CAPS = CAP_GENCON_INVERSE

generic_console_ioctl:
	scf
generic_console_set_ink:
generic_console_set_paper:
generic_console_set_attribute:
	ret

generic_console_cls:
	ld	hl,CONSOLE_DISPLAY
	ld	de,CONSOLE_DISPLAY+1
	ld	bc,+(CONSOLE_COLUMNS * CONSOLE_ROWS) -1
	ld	(hl),32
	ldir
	ret


; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
	rr	e
	call	nc,map_character
	call	xypos
	ld	(hl),a
	ret

map_character:
	call	asm_toupper
	ld	hl,generic_console_flags
	bit	7,(hl)
	ret	z
	or	128
	ret
	

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character
;        c = failure
generic_console_vpeek:
	ld	a,e
        call    xypos
	rra
	ld	a,(hl)
	ccf
	ret	nc 		;raw mode
	and	127
	ret


; b = row
; c = column
xypos:
        ld      hl,CONSOLE_DISPLAY - CONSOLE_COLUMNS
        ld      de,CONSOLE_COLUMNS
        inc     b
generic_console_printc_1:
        add     hl,de
        djnz    generic_console_printc_1
generic_console_printc_3:
        add     hl,bc                   ;hl now points to address in display
        ret


generic_console_scrollup:
	push	de
	push	bc
	ld	hl, CONSOLE_DISPLAY + CONSOLE_COLUMNS
	ld	de, CONSOLE_DISPLAY
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
