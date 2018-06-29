;
; The Multi8 can operate in multiple modes
;
; - Text/character based - 40x25, 80x25 there's attributes there as well
; - Full RGB - they actually end up being superimposed on each other (when in text mode)
;
;
; Text mode = two bytes get written 2k apart
;

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		EXTERN		l_push_di
		EXTERN		l_pop_ei

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		defc		DISPLAY = 0x8000

generic_console_ioctl:
	scf
generic_console_set_ink:
generic_console_set_paper:
generic_console_set_inverse:
	ret

generic_console_cls:
	call	l_push_di
	ld	a,0x17		
	out	($2a),a
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc, 80 * 25 - 1
	ld	(hl),32
	ldir
	ld	a,0xf
	out	($2a),a
	call	l_pop_ei
	ret

; c = x
; b = y
; a = d character to print
; e = raw
generic_console_printc:
	sla	c		;40 column to 80 columns translation
	call	xypos
	ld	e,a
        call    l_push_di
        ld      a,0x17       
        out     ($2a),a
	ld	(hl),e
	ld	bc,0x800
	add	hl,bc
	ld	a,(__multi8_attr)
	ld	(hl),a
	ld	a,0xf
	out	($2a),a
	call	l_pop_ei
	ret

;Entry: c = x,
;	b = y
;Exit:	nc = success
;	 a = character,
;	 c = failure
generic_console_vpeek:
	sla	c		;40 column to 80 columns translation
	call	xypos
	call	l_push_di
	ld	a,0x17
	out	($2a),a
	ld	b,(hl)
	ld	a,0xf
	out	($2a),a
	call	l_pop_ei
	ld	a,b
	and	a
	ret

xypos:
	ld	hl, DISPLAY - 80
	ld	de,80
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	ret

generic_console_scrollup:
	push	de
	push	bc
	call	l_push_di
	ld	a,0x17
	out	($2a),a
	ld	hl, DISPLAY + 80
	ld	de, DISPLAY
	ld	bc, 80 * 25
	ldir
	; And blank out row 15
	ex	de,hl
	ld	b,80
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	ld	a,0xf
	out	($2a),a
	call	l_pop_ei
	pop	bc
	pop	de
	ret


	SECTION		bss_clib

__multi8_attr:	defb	0
