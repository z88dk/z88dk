

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute
		PUBLIC		__eg2000_custom_font
		PUBLIC		__eg2000_mode

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		EG2000_ENABLED
		EXTERN		CRT_FONT
		EXTERN		conio_map_colour
		
		EXTERN		base_graphics

		defc		COLOUR_MAP = 0xF000
		defc		CHAR_TABLE = 0xF400
		defc		EG2000_COLOUR_OFFSET = (COLOUR_MAP - 0x4400) /256


generic_console_set_ink:
	call	conio_map_colour
	and	15
	ld	(__eg2000_attr),a
	ret

generic_console_set_paper:
generic_console_set_attribute:
	ret

generic_console_cls:
	ld	hl, (base_graphics)
	ld	d,h
	ld	e,l
	inc 	de
	ld	bc,1023
	ld	(hl),32
	ldir
	ld	a,EG2000_ENABLED
	and	a
	ret	z
	ld	hl,COLOUR_MAP
	ld	de,COLOUR_MAP+1
	ld	bc,1023
	ld	a,(__eg2000_attr)
	ld	(hl),a
	ldir
	ret


; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	push	de
	call	xypos
	pop	de
	ld	d,a
	ld	a,EG2000_ENABLED
	and	a
	ld      a,(__eg2000_mode)
	jr	nz,eg2000_printc
	ld	(hl),d
	ret

eg2000_printc:
	rr	e
	jr	c,is_raw
        ld      a,(__eg2000_custom_font)
        and     a
	ld      a,(__eg2000_mode)
	jr	z,is_raw
	set	7,d	;custom font define, use chars 160-255 for font, 128-159=udgs
is_raw:
	out     (0xff),a
	ld	(hl),d
	ld	a,h
	add	EG2000_COLOUR_OFFSET
	ld	h,a
	ld	a,(__eg2000_attr)
	ld	(hl),a
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	ld	a,e
        call    xypos
	ld	e,a
	ld	d,(hl)
	rr	e
	call	nc,vpeek_unmap
	ld	a,d
	and	a
	ret

vpeek_unmap:	
	ld	a,(__eg2000_custom_font)
	and	a
	ret	z
	ld	a,d
	cp	160
	ret	c
	res	7,d
	ret

xypos:
	ld	hl, (base_graphics)
	ld	de,CONSOLE_COLUMNS
	inc	b
	sbc hl,de
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	hl, CONSOLE_COLUMNS
	ld	de, (base_graphics)
	add	hl,de
	ld	bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	ld	a,EG2000_ENABLED
	and	a
	jr	z,scrollup_return
	ld	hl,COLOUR_MAP + CONSOLE_COLUMNS
	ld	de,COLOUR_MAP
        ld      bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
        ldir
        ex      de,hl
        ld      b,CONSOLE_COLUMNS
	ld	a,(__eg2000_attr)
generic_console_scrollup_4:
        ld      (hl),a
        inc     hl
        djnz    generic_console_scrollup_4
scrollup_return:
	pop	bc
	pop	de
	ret

	SECTION		bss_clib

__eg2000_mode:  defb	0
__eg2000_attr:	defb	0
__eg2000_custom_font:	defb	0

	SECTION		code_crt_init

	EXTERN		asm_set_cursor_state

	ld	a,EG2000_ENABLED
	and	a
	jr	z,no_set_font
	ld      l,0x20          ;disable cursor
        call    asm_set_cursor_state
	ld	hl,CRT_FONT
	ld	a,h
	or	l
	jr	z,no_set_font
	ld	(__eg2000_custom_font),a
	ld	de,CHAR_TABLE+256
	ld	bc,768
	ldir
no_set_font:

	SECTION	code_crt_exit
	EXTERN	__console_x
	ld	bc,(__console_x)
	call	xypos
	ld	($4020),hl	
