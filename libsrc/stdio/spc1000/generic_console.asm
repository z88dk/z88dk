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
		EXTERN		__spc1000_attr
		EXTERN		__console_w

		defc		DISPLAY = 0x0000
		defc		COLOUR_MAP = 0xf800


generic_console_set_inverse:
generic_console_set_paper:
	ret

generic_console_set_ink:
	and	3
	ld	(__spc1000_attr),a
	ret
	

generic_console_cls:
	ld	bc,0
	ld	hl, CONSOLE_ROWS * CONSOLE_COLUMNS
cls_1:
	ld	a,' '
	out	(c),a
	inc	bc
	dec	hl
	ld	a,h
	or	l
	jr	nz,cls_1
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
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
	pop	bc
	pop	de
	ret

	SECTION	data_clib

__spc1000_attr:	defb	1
