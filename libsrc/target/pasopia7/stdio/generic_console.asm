;
;


		SECTION		code_driver

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute

		EXTERN		generic_console_flags
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		conio_map_colour
		EXTERN		__pasopia_page
		EXTERN		__console_w

		INCLUDE		"target/pasopia7/def/pasopia7.def"

generic_console_set_attribute:
	ld	a,(generic_console_flags)
	rrca
	rrca
	rrca
	rrca
	and	8
	ld	e,a
	ld	a,(__pasopia7_attr)
	and	@11110111
	or	e
	ld	(__pasopia7_attr),a
	ret

generic_console_set_ink:
	call	conio_map_colour
	and	7
	ld	e,a
	ld	a,(__pasopia7_attr)
	and	@11111000
	or	e
	ld	(__pasopia7_attr),a
	ret

	
generic_console_set_paper:
	ret

generic_console_cls:
	ld	a,(__pasopia_page)
	or	4		; Page VRAM in
	out	(MEM_MODE),a
	ld	a,$44
	out	(VRAM_PLANE),a

	ld	a,(__pasopia7_attr)
	out	(DISP_CTRL),a		;Set attribute data	
	ld	bc, 80 * 25
	ld	hl, $8000
	ld	de,8
cls_loop:
	ld	(hl),' '
	add	hl,de
	dec	bc
	ld	a,b
	or	c
	jr	nz,cls_loop

	ld	a,(__pasopia_page)
	out	(MEM_MODE),a

	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	call	xypos
	ld	d,a		;Save attribute
	ld	a,(__pasopia_page)
	or	4		; Page VRAM in
	out	(MEM_MODE),a
	ld	a,(__pasopia7_attr)
	out	(DISP_CTRL),a		;Set attribute
	ld	a,$44		;Select text VRAM
	out	(VRAM_PLANE),a
	ld	(hl),d
	ld	a,(__pasopia_page)
	out	(MEM_MODE),a
	ret


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        call    xypos
	ld	a,(__pasopia_page)
	or	4		; Page VRAM in
	out	(MEM_MODE),a
        ld      d,(hl)
	xor	4
	out	(MEM_MODE),a
	ld	a,d
        and     a
        ret


xypos:
	ld	hl,(__console_w)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ex	de,hl
	ld	hl,$8000 
	and	a
	sbc	hl,de
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	ex	de,hl
	ld	l,c
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,de
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	a,(__pasopia_page)
	or	4		; Page VRAM in
	out	(MEM_MODE),a
	ld	a,$44
	out	(VRAM_PLANE),a

	ld	hl,(__console_w)
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld	bc,$8000
	add	hl,bc
	ld	de,$8000

	ld	c,24
scroll_row:
	ld	a,(__console_w)
	ld	b,a
scroll_char:
	push	bc
	ld	a,(hl)
	ld	(de),a
	ld	bc,8
	add	hl,bc
	ex	de,hl
	add	hl,bc
	ex	de,hl
	pop	bc
	djnz	scroll_char
	dec	c
	jr	nz,scroll_row

	; And we have to clear the bottom line
	ld	a,(__console_w)
	ld	b, CONSOLE_ROWS - 1
	ld	c,0
scroll_1:
	push	af
	push	bc
	ld	e,0
	ld	a,' '
	call	generic_console_printc
	pop	bc
	inc	c
	pop	af
	dec	a
	jr	nz,scroll_1


	ld	a,(__pasopia_page)
	out	(MEM_MODE),a

	pop	bc
	pop	de
	ret

	SECTION		data_clib

__pasopia7_attr:
	defb		7

	SECTION		code_crt_init
	EXTERN		asm_set_cursor_state

	ld	a,0			;Disable cursor blinking (bit 5)
					;No attribute wrap (bit 4)
	out	(VIDEO_MISC),a		;Video PIO, port C
        ld      l,$20
        call    asm_set_cursor_state
	
