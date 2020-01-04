
		; code_driver to ensure we don't page ourselves out
		SECTION		code_driver

		PUBLIC		generic_console_calc_xypos
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute

		EXTERN		__mc1000_modeval
		EXTERN		__mc1000_mode

		EXTERN		printc_MODE1
		EXTERN		printc_MODE2


		EXTERN		generic_console_flags
		EXTERN		__ink_colour
		EXTERN		__MODE2_attr
		EXTERN		mc6847_map_colour
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		CRT_FONT
		EXTERN		__console_w

		defc		DISPLAY = 0x8000

generic_console_set_ink:
        call    mc6847_map_colour
        ld      a,b
        rrca
        rrca
        and     @11000000
        ld      (__MODE2_attr),a
	ret
generic_console_set_paper:
        call    mc6847_map_colour
        ld      a,b
        rrca
        rrca
        and     @11000000
        ld      (__MODE2_attr+1),a
generic_console_set_attribute:
	ret


; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
	ld	a,(__mc1000_mode)
	cp	1
	jp	z,printc_MODE1
	cp	2
	jp	z,printc_MODE2
; Text mode
	ld	a,(__mc1000_modeval)
	out	($80),a
	ex	af,af
	push	de
	call	generic_console_calc_xypos
	pop	de
	rr	e
	call	nc,convert_character
	ld	(hl),d
	ex	af,af
	set	0,a
	out	($80),a		;
	ret


generic_console_calc_xypos:
	ld	hl,DISPLAY - CONSOLE_COLUMNS
	ld	de,CONSOLE_COLUMNS
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
	add	hl,bc			;hl now points to address in display
	ret

convert_character:
	ld	a,d
        cp      97
        jr      c,isupper
        sub     32
.isupper
        and     @00111111
	ld	d,a
	ld	a,(generic_console_flags)
	rlca
	ret	nc
	set	7,d
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	a,(__mc1000_mode)
	and	a
	jp	nz,hires_scrollup

text_scrollup:
	ld	a,(__mc1000_modeval)
	out	($80),a
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
	set	0,a
	out	($80),a
	pop	bc
	pop	de
	ret

hires_scrollup:
	ld	a,(__mc1000_modeval)
	res	0,a
	out	($80),a
        ld      de,DISPLAY
	ld	h,d
	ld	l,e
        inc     h
        ld      bc,32 * 184
        ldir
	set	0,a
	out	($80),a
	ld	bc,(__console_w)
	dec	b
	ld	a,c		;console_w
	ld	c,0
clear_last_row:
	push	af
	push	bc
	ld	a,32
	ld	d,a
	ld	e,0
	call	generic_console_printc
	pop	bc
	inc	c
	pop	af
	dec	a
	jr	nz,clear_last_row


        pop     bc
        pop     de
	ret
