;
;
; The Nascom has a strange screen 
;
; Video memory starts at 0x800 and is 0x400 bytes long
;
; The top row is actually row 16
; The video memory is 64 bytes per row
; - But display starts at offset 10 and is 48 characters
;

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

		defc		DISPLAY = 0x0800
                defc            TOPROW = DISPLAY + (CONSOLE_ROWS - 1) * 64 + 10

		PUBLIC          CLIB_GENCON_CAPS
		defc            CLIB_GENCON_CAPS = 0


generic_console_ioctl:
	scf
generic_console_set_ink:
generic_console_set_paper:
generic_console_set_attribute:
	ret

generic_console_cls:
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc,1023
	ld	(hl),32
	ldir
	ret

; c = x
; b = y
; a = d character to print
; e = raw
generic_console_printc:
	call	xypos
	ld	(hl),a
	ret

;Entry: c = x,
;	b = y
;Exit:	nc = success
;	 a = character,
;	 c = failure
generic_console_vpeek:
	call	xypos
	ld	a,(hl)
	and	a
	ret

xypos:
	ld	hl,TOPROW
	ld	a,b
	and	a
	ld	a,d		
	jr	z,generic_console_printc_3
	ld	hl, DISPLAY - 64 + 10
	ld	de,64
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	ret

generic_console_scrollup:
	push	de
	push	bc
	; Move row 1 to row 0
	ld	hl, DISPLAY
	ld	de, TOPROW
	ld	bc, 64
	ldir
	; Move Row 2-15 to row 1-14
	ld	hl, DISPLAY + 64
	ld	de, DISPLAY
	ld	bc, 14 * 64
	ldir
	; And blank out row 15
	ex	de,hl
	ld	b,64
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	pop	bc
	pop	de
	ret
