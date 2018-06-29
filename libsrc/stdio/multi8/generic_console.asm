;
; The Multi8 can operate in multiple modes
;
; - Text/character based - 40x25, 80x25 there's attributes there as well
; - Full RGB - they actually end up being superimposed on each other (when in text mode)
;
;
; Text mode = two bytes get written 2k apart
;

		; In code_driver so we are low down in memory and hopefully
		; never paged out
		SECTION		code_driver

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
		EXTERN		__vram_in
		EXTERN		__vram_out

		defc		DISPLAY = 0x8000

generic_console_set_ink:
	and	7
	ld	b,a
	ld	a,(__multi8_attr)
	and	248
	or	b
	ld	(__multi8_attr),a
	ret

	
generic_console_ioctl:
	scf
generic_console_set_paper:

generic_console_set_inverse:
	ld	a,(__multi8_attr)
	and	0xdf
	bit	7,(hl)
	jr	z,store
	or	0x20
store:
	ld	(__multi8_attr),a
	ret

generic_console_cls:
	call	l_push_di
	ld	a,(__vram_in)
	out	($2a),a
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc, 80 * 25 - 1
	ld	(hl),32
	ldir
	ld	hl, DISPLAY + 0x800
	ld	de, DISPLAY + 0x800 + 1
	ld	bc, 80 * 25 - 1
	ld	a,(__multi8_attr)
	ld	(hl),a
	ldir
	ld	a,(__vram_out)
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
	ld	a,(__vram_in)
        out     ($2a),a
	ld	(hl),e
	ld	bc,0x800
	add	hl,bc
	ld	a,(__multi8_attr)
	ld	(hl),a
	ld	a,(__vram_out)
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
	ld	a,(__vram_in)
	out	($2a),a
	ld	b,(hl)
	ld	a,(__vram_out)
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
	ld	a,(__vram_in)
	out	($2a),a
	ld	hl, DISPLAY + 80
	ld	de, DISPLAY
	ld	bc, 80 * 24
	ldir
	ex	de,hl
	ld	b,80
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	ld	hl, DISPLAY + 0x800 + 80
	ld	de, DISPLAY + 0x800
	ld	bc,80 * 24
	ldir
	; blank out last row
	ex	de,hl
	ld	b,80
	ld	a,(__multi8_attr)
generic_console_scrollup_4:
	ld	(hl),a
	inc	hl
	djnz	generic_console_scrollup_4
	ld	a,(__vram_out)
	out	($2a),a
	call	l_pop_ei
	pop	bc
	pop	de
	ret


	SECTION		data_clib

__multi8_attr:	defb	0x07		;white ink

	SECTION		code_crt_init

	; Enable colour text mode
	ld	a,($f0bb)
	and	127
	ld	($f0bb),a
	out	($29),a

IF write_palette
	xor	a
	out	($30),a
	inc	a
	out	($31),a
	inc	a
	out	($32),a
	inc	a
	out	($33),a
	inc	a
	out	($34),a
	inc	a
	out	($35),a
	inc	a
	out	($36),a
	inc	a
	out	($37),a
ENDIF
