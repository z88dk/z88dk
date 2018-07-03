;
;


		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		CRT_FONT
		EXTERN		__spc1000_attr
		EXTERN		__spc1000_mode
		EXTERN		__console_w

		defc		DISPLAY = 0x0000


generic_console_set_inverse:
generic_console_set_paper:
	ret

generic_console_set_ink:
	and	3
	ld	(__spc1000_attr),a
	ret
	

generic_console_cls:
	ld	a,(__spc1000_mode)
	cp	1
	jr	z,cls_hires
	ld	bc,0
	ld	hl, CONSOLE_ROWS * CONSOLE_COLUMNS
cls_1:
	ld	a,' '
	out	(c),a
	set	3,b
	ld	a,(__spc1000_attr)
	out	(c),a
	res	3,b
	inc	bc
	dec	hl
	ld	a,h
	or	l
	jr	nz,cls_1
	ret

cls_hires:
	ld	bc,0
	ld	hl, +(32 * 24 * 8)
	ld	e,0
cls_hires_1:
	out	(c),e
	inc	bc
	dec	hl
	ld	a,h
	or	l
	jr	nz,cls_hires_1

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	ld	d,a		;Save character
	ld	a,(__spc1000_mode)
	cp	1
	jr	z,printc_hires
	ld	a,d
	call	xypos
	ld	c,l
	ld	b,h
	cp	$60
	jr	c,not_lower
	; We do something with characters > 0xe0 here
	and	$7f
	out	(c),a
	ld	a,(__spc1000_attr)
	and	3
	or	8
write_attr:
	set	3,b
	out	(c),a
	ret
not_lower:
	out	(c),a
	ld	a,(__spc1000_attr)
	jr	write_attr

printc_hires:
	ld	l,d
	ld	h,0
	ld	de,(__spc1000_font)
	bit	7,l
	jr	z,not_udg
	res	7,l
	ld	de,(__spc1000_udg)
	inc	d	
not_udg:
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,de
	dec	h
	ex	de,hl		;de = font
	; bc is already set 

	ld	l,8
hires_printc_1:
	ld	a,(de)
	out	(c),a
	ld	a,c
	add	32
	ld	c,a
	jr	nc,no_overflow
	inc	b
no_overflow:
	inc	de
	dec	l
	jr	nz,hires_printc_1
	ret






;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        call    xypos
	ld	c,l
	ld	b,h
        in	a,(c)
        and     a
        ret


xypos:
	ld	hl,DISPLAY
	ld	de,(__console_w)
	ld	d,0
	and	a
	sbc	hl,de
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	a,(__spc1000_mode)
	cp	1
	jr	z,scrollup_hires
	ld	bc, CONSOLE_COLUMNS	;source
	ld	hl, +((CONSOLE_ROWS -1)* CONSOLE_COLUMNS)
scroll_loop:
	push	hl
	in	e,(c)
	set	3,b
	in	d,(c)
	res	3,b
	ld	hl,-CONSOLE_COLUMNS
	add	hl,bc
	ld	c,l
	ld	b,h
	out	(c),e
	set	3,b
	out	(c),d
	res	3,b
	ld	hl,CONSOLE_COLUMNS + 1
	add	hl,bc
	ld	c,l
	ld	b,h
	pop	hl
	dec	hl
	ld	a,h
	or	l
	jr	nz,scroll_loop

	ld	hl,-CONSOLE_COLUMNS
	add	hl,bc
	ld	c,l
	ld	b,h
	ld	e,32
	ld	d,' '
	ld	a,(__spc1000_attr)
scroll_loop_2:
	out	(c),d
	set	3,b
	out	(c),a
	res	3,b
	inc	bc
	dec	e
	jr	nz,scroll_loop_2
	pop	bc
	pop	de
	ret

scrollup_hires:
	ld	bc, 32 * 8
	ld	hl, +(32 * 23 * 8)
scroll_hires_1:
	in	e,(c)
	dec	b
	out	(c),e
	inc	b
	inc	bc
	dec	hl
	ld	a,h
	or	l
	jr	nz,scroll_hires_1
	pop	bc
	pop	de
	ret


	SECTION	data_clib

__spc1000_attr:	defb	1
__spc1000_mode:	defb	0		;Mode 0 = text
					;Mode 1 = hires 

__spc1000_font:  defw    CRT_FONT
__spc1000_udg:   defw    0
