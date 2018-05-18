
		; code_driver to ensure we don't page ourselves out
		SECTION		code_driver

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		PUBLIC		__mc1000_mode
		PUBLIC		__mc1000_font
		PUBLIC		__mc1000_udg

		EXTERN		ansi_cls
		EXTERN		ansi_SCROLLUP

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		CRT_FONT

		defc		DISPLAY = 0x8000

generic_console_set_ink:
generic_console_set_paper:
generic_console_set_inverse:
	ret

generic_console_cls:
	ld	a,(__mc1000_mode)
	cp	0x9e
	jp	z,ansi_cls
	out	($80),a
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	(hl),32
	ldir
	set	0,a
	out	($80),a
	ret

; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
	ld	a,(__mc1000_mode)
	cp	0x9e
	jr	z,hires_printc
; Text mode
	out	($80),a
	push	af		;Give CPU stack is safe
	ld	a,d
	call	xypos
	rr	e
	call	nc,convert_character
	ld	(hl),a
	pop	af
	set	0,a
	out	($80),a		;
	ret


; c = x
; b = y
; d = character
; e = raw
; a = screen port
hires_printc:
	ex	af,af		;save port
	ld	l,d
	ld	h,0
	ld	de,(__mc1000_font)
	bit	7,l
	jr	z,not_udg
	res	7,l		;take off 128
	ld	de,(__mc1000_udg)
	inc	d		;We decrement later
not_udg:
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,de
	dec	d		; -32 characters
	ex	de,hl		; de = font
	ld	h,b		; 32 * 8
	ld	l,0
	ld	bc,DISPLAY
	add	hl,bc		;hl = screen

	ld	b,8
hires_printc_1:
	ld	a,(de)
	ld	c,a
	ex	af,af
	res	0,a
	out	($80),a		;VRAM -> Z80
	ld	(hl),c
	set	0,a
	out	($80),a		;VRAM -> Chip
	ex	af,af
	inc	de
	ld	a,l
	add	32
	ld	l,a
	jr	nc,no_overflow
	inc	h
no_overflow:
	djnz	hires_printc_1
	ret


;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	ld	a,(__mc1000_mode)
	cp	0x9e
	jr	z,vpeek_hires
        call    xypos
	ld	a,(hl)
	and	a
	ret

vpeek_hires:
	scf
	ret


xypos:
	ld	hl,DISPLAY - CONSOLE_COLUMNS
	ld	de,CONSOLE_COLUMNS
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	ret

convert_character:
        cp      97
        jr      c,isupper
        sub     32
.isupper
        and     @00111111
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	a,(__mc1000_mode)
	cp	0x9e
	jr	nz,text_scrollup
	call	ansi_SCROLLUP
	pop	bc
	pop	de
	ret

text_scrollup:
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

	SECTION	data_clib

__mc1000_mode:	defb	0x9e		;hires mode
__mc1000_font:	defw	CRT_FONT
__mc1000_udg:	defw	0
