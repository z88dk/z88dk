;
;


		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse
		PUBLIC		generic_console_calc_xypos
		PUBLIC		generic_console_plotc
		PUBLIC		generic_console_pointxy
		PUBLIC		__spc1000_attr

		EXTERN		printc_MODE1
		EXTERN		printc_MODE2

		EXTERN		__MODE2_attr

		EXTERN		tms9918_cls
		EXTERN		tms9918_scrollup
		EXTERN		tms9918_printc
                EXTERN          tms9918_set_ink
                EXTERN          tms9918_set_paper
                EXTERN          tms9918_set_inverse
		EXTERN		generic_console_flags
		EXTERN		mc6847_map_colour


		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		__spc1000_mode
		EXTERN		__console_w

		defc		DISPLAY = 0x0000


generic_console_set_inverse:
	ld	b,a
        ld      a,(hl)
        ld      c,0
        rlca
        rl      c
        ld      a,(__spc1000_attr)
        and     254
        or      c
        ld      (__spc1000_attr),a
	ld	a,(__spc1000_mode)
	cp	10
	ld	a,b
	jp	z,tms9918_set_inverse
	ret

generic_console_set_paper:
	push	af
	call	mc6847_map_colour
	ld	a,b
        rrca
        rrca
        and     @11000000
        ld      (__MODE2_attr+1),a
	call	set_css
	pop	af
	ld	b,a
	ld	a,(__spc1000_mode)
	cp	10
	ld	a,b
	jp	z,tms9918_set_paper
	ret

generic_console_set_ink:
	push	af
	call	mc6847_map_colour
	ld	a,b
        and     7
        ld      (__ink_colour),a
        rrca
        rrca
        and     @11000000
        ld      (__MODE2_attr),a
	call	set_css
	pop	af
	ld	a,(__spc1000_mode)
	cp	10
	ld	a,b
	jp	z,tms9918_set_ink
	ret

set_css:
	ld	a,b
	rlca	
	rlca
	and	@00000010	
	ld	c,a
	ld	a,(__spc1000_attr)
	and	@11111101
	or	c
	ld	(__spc1000_attr),a
	ret
	

generic_console_cls:
	ld	a,(__spc1000_mode)
	and	a
	jr	z,cls_text
	cp	10
	jp	z,tms9918_cls
	jr	cls_hires
cls_text:
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


generic_console_pointxy:
        call    generic_console_calc_xypos
	ld	c,l
	ld	b,h
	in	l,(c)
	set	3,b
	in	a,(c)
        and     @00011101
        cp      @00011101
        ld      a,0             ;No graphics drawn
        ret     nz              ;Not a graphics character
        ld      a,l
        and     @00111111
        ret


generic_console_plotc:
        call    generic_console_calc_xypos
	ld	c,l
	ld	b,h
        ld      l,a
        ld      a,(__MODE2_attr)                ;It's shifted for us
        and     @11000000
        or      l
	out	(c),a
	set	3,b
        ld      a,(__ink_colour)
        rrca
        and     2                               ;Set the CSS flag as appropriate
        or      @00011101                       ;3x2, CSS not set
	out	(c),a
        ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	ld	d,a		;Save character
	ld	a,(__spc1000_mode)
	cp	1
	jp	z,printc_MODE1
	cp	2
	jp	z,printc_MODE2
	cp	10
	ld	a,d
	jp	z,tms9918_printc
	call	generic_console_calc_xypos
	ld	c,l
	ld	b,h
	cp	$60
	jr	c,hardware_chars
	; We do something with characters > 0xe0 here
	cp	$e0
	jr	nc,high_chars
	and	$7f
	out	(c),a
	ld	a,(__spc1000_attr)
	and	3
	or	8
write_attr:
	set	3,b
	out	(c),a
	ret
high_chars:
	and	$f
	ld	d,a
	ld	a,(__spc1000_attr)
	dec	a
	and	7
	rlca
	rlca
	rlca
	rlca
	or	d
	out	(c),a
	ld	a,(__spc1000_attr)
	or	4
	jr	write_attr

hardware_chars:
	out	(c),a
	ld	a,(__spc1000_attr)
	jr	write_attr




generic_console_calc_xypos:
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
	ld	a,(__spc1000_mode)
	cp	10
	jp	z,tms9918_scrollup
	push	de
	push	bc
	and	a
	jr	z,scrollup_text
	jr	scrollup_hires
scrollup_text:
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
	ld	l,0
	xor	a
scrollup_hires_2:
	out	(c),a
	inc	bc
	dec	l
	jr	nz,scrollup_hires_2
	pop	bc
	pop	de
	ret


	SECTION	data_clib

__spc1000_attr:	defb	0
__ink_colour:   defb    7
