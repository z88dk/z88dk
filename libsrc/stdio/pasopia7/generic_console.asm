;
;


		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		__pasopia_page
		EXTERN		__console_w


generic_console_ioctl:
	scf
generic_console_set_inverse:
	ret

generic_console_set_ink:
	and	15
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
	out	($3c),a
	ld	a,$44
	out	($0c),a

	ld	bc, CONSOLE_COLUMNS * CONSOLE_ROWS
	ld	hl, $8000
	ld	de,8
cls_loop:
	ld	a,(__pasopia7_attr)
	out	($0d),a		;Set attribute data	
	ld	(hl),' '
	add	hl,de
	dec	bc
	ld	a,b
	or	c
	jr	nz,cls_loop

	ld	a,(__pasopia_page)
	out	($3c),a

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
	out	($3c),a
	ld	a,(__pasopia7_attr)
	out	($0d),a		;Set attribute
	ld	a,$44		;Select text VRAM
	out	($0c),a
	ld	(hl),d
	ld	a,(__pasopia_page)
	out	($3c),a
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
	out	($3c),a
        ld      d,(hl)
	xor	4
	out	($3c),a
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
	out	($0a),a		;Video PIO, port C
        ld      l,$20
        call    asm_set_cursor_state
	
