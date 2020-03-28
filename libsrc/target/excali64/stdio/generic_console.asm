;
;

		SECTION		code_graphics

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute
                PUBLIC          generic_console_plotc
                PUBLIC          generic_console_pointxy

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		__excali64_attr
		EXTERN		__excali64_inverse_attr
		EXTERN		__console_w
		EXTERN		__console_h
		EXTERN		__excali64_font32
		EXTERN		__excali64_udg32

		EXTERN		conio_map_colour
		EXTERN		conio_map_colour_bg

		defc		DISPLAY = $2000
		defc		COLOUR_MAP = $2800
		defc		HIRES_MAP = $3000

generic_console_set_attribute:
	ld	a,(hl)
	ld	(t_flags),a
	ret

generic_console_set_ink:
	push	af
	ld	de,__excali64_attr
	call	set_ink
	pop	af
	ld	de,__excali64_inverse_attr
	jr	set_paper

set_ink:
	call	conio_map_colour
	and	15
	rla
	rla
	rla
	rla	
	ld	c,a
	ld	a,(de)
	and	@00001111
	or	c
	ld	(de),a
	ret

	
generic_console_set_paper:
	push	af
	ld	de,__excali64_attr
	call	set_paper
	pop	af
	ld	de,__excali64_inverse_attr
	jr	set_ink

set_paper:
	call	conio_map_colour_bg
	rlca
	and	@00001110
	ld	c,a
	ld	a,(de)
	and	@11110001
	or	c
	ld	(de),a
	ret

generic_console_cls:
	in	a,($50)
	bit	4,a
	jr	z,generic_console_cls
	push	af
	res	1,a
	set	0,a
	out	($70),a
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	(hl),32
	ldir
	ld	hl, COLOUR_MAP
	ld	de, COLOUR_MAP+1
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	a,(__excali64_attr)
	ld	(hl),a
	ldir
	ld	hl, HIRES_MAP
	ld	de, HIRES_MAP + 1
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	(hl),4		;PCG bank 0
	ldir
	pop	af
	out	($70),a
	ret


generic_console_plotc:
	call	xypos
	ld	d,a
plotc_ready:
        in      a,($50)
        bit     4,a
        jr      z,plotc_ready
        push    af
        res     1,a
        set     0,a
        out     ($70),a
        ld      (hl),d
	ld	a,h
	add	8
	ld	h,a
	call	get_attr
	ld	(hl),b
	set	0,(hl)
	ld	a,h
	add	8
	ld	h,a
	ld	(hl),5		;PCG bank
	pop	af
	out	($70),a
	ret


; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	call	xypos
	ld	d,a
printc_ready:
	in	a,($50)
	bit	4,a
	jr	z,printc_ready
	push	af
	res	1,a
	set	0,a
	out	($70),a
	ld	(hl),d
	ld	a,h
	add	8
	ld	h,a
	call	get_attr
	ld	(hl),b
	; If we've got custom font or UDGs we need to toggle some bits
	; and set the PCG bank reference
	ld	bc,(__excali64_font32)
	bit	7,d		;d = character being printed
	jr	z,not_udg
	ld	bc,(__excali64_udg32)
not_udg:
	ld	a,b
	or	c
	jr	z,not_custom
	set	0,(hl)		;toggle graphics flag on attributes
	ld	a,h
	add	8
	ld	h,a
	ld	(hl),4		;PCG bank 0
not_custom:
	pop	af
	out	($70),a
	ret

get_attr:
	ld	a,(__excali64_attr)
	ld	b,a
	ld	a,(t_flags)
	rlca
	ret	nc
	ld	a,(__excali64_inverse_attr)
	ld	b,a
	ret

;Check for a graphics character
;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_pointxy:
        call    xypos
	in	a,($50)
	push	af
	res	1,a
	set	0,a
	out	($70),a
        ld      d,(hl)
	ld	a,h
	add	16
	ld	h,a
	ld	a,(hl)
	cp	5		;PCG bank
	jr	z,is_graphics_pcg
	ld	d,0
is_graphics_pcg:
	pop	af
	out	($70),a
	ld	a,d
	and	a
	ret

;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        call    xypos
	in	a,($50)
	push	af
	res	1,a
	set	0,a
	out	($70),a
        ld      d,(hl)
	pop	af
	out	($70),a
	ld	a,d
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
	ld	hl,(__console_w)
	ld	(t_console_w),hl
scroll_ready:
	in	a,($50)
	bit	4,a
	jr	z,scroll_ready
	push	af
	res	1,a
	set	0,a
	out	($70),a

	ld	hl, DISPLAY
	ld	de, (t_console_w)
	ld	d,0
	add	hl,de
	ld	de, DISPLAY
	ld	a,(t_console_h)
	dec	a
scroll_1:
	ld	bc,(t_console_w)
	ld	b,0
	ldir
	dec	a
	jr	nz,scroll_1

	ex	de,hl
	ld	a,(t_console_w)
	ld	b,a
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3

	ld	hl, COLOUR_MAP
	ld	de, (t_console_w)
	ld	d,0
	add	hl,de
	ld	de, COLOUR_MAP
	ld	a,(t_console_h)
	dec	a
scroll_2:
	ld	bc,(t_console_w)
	ld	b,0
	ldir
	dec	a
	jr	nz,scroll_2
	ex	de,hl
	ld	a,(t_console_w)
	ld	b,a
	ld	a,(__excali64_attr)
generic_console_scrollup_4:
	ld	(hl),a
	inc	hl
	djnz	generic_console_scrollup_4

	ld	hl, HIRES_MAP
	ld	de, (t_console_w)
	ld	d,0
	add	hl,de
	ld	de, HIRES_MAP
	ld	a,(t_console_h)
	dec	a
scroll_3:
	ld	bc,(t_console_w)
	ld	b,0
	ldir
	dec	a
	jr	nz,scroll_3
	ex	de,hl
	ld	a,(t_console_w)
	ld	b,a
	ld	a,4		;PCG bank 0
generic_console_scrollup_5:
	ld	(hl),a
	inc	hl
	djnz	generic_console_scrollup_5


	pop	af
	out	($70),a
	pop	bc
	pop	de
	ret


	SECTION	bss_graphics

t_console_w:	defb	0
t_console_h:	defb	0
t_flags:	defb	0

        SECTION code_crt_init

        EXTERN  asm_set_cursor_state
        ld      l,$20
        call    asm_set_cursor_state

