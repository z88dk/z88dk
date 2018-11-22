
	SECTION	code_clib
	PUBLIC	printc_MODE2

	EXTERN	__pc88_ink
	EXTERN	__pc88_paper
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32
	EXTERN	generic_console_flags

	EXTERN	l_push_di
	EXTERN	l_pop_ei


printc_MODE2:
        ld      a,d
        call    generic_console_xypos_graphics
        ex      de,hl           ;de = destination
        ld      bc,(generic_console_font32)
        ld      l,a
        ld      h,0
        bit     7,l
        jr      z,not_udg
        res     7,l
        ld      bc,(generic_console_udg32)
        inc     b
not_udg:
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,bc
        dec     h               ;-32 characters
        ex      de,hl           ;hl = screen, de = font

        ld      a,(generic_console_flags)
        rlca            ;get bit 7 out
        sbc     a
        ld      c,a     ; c = 0/ c = 255

	call	l_push_di
	ld	b,8
loop:	push	bc
	ld	a,(de)		;pick up font form main memory
	xor	c
	exx
	ld	h,a		;save ink version
	cpl
	ld	l,a		;save paper version

	ld	de,(__pc88_ink)
	
	rrc	e	;Ink
	ld	a,e
	sbc	a,a	;= 255 if it was set
	and	h
	ld	c,a	;Contains ink blue to be set

	rrc	d	;paper
	ld	a,d
	sbc	a,a	;255 if set, 0 = if not set
	and	l
	or	c	;So now we have the blue byte

	out	($5c),a	;Switch to blue
	exx
	ld	(hl),a	;And write it
	exx

	rrc	e	;Ink
	ld	a,e
	sbc	a,a	;= 255 if it was set
	and	h
	ld	c,a	;Contains ink green to be set

	rrc	d	;paper
	ld	a,d
	sbc	a,a	;
	and	l
	or	c	;So now we have the green byte

	out	($5e),a	;Switch to green
	exx
	ld	(hl),a	;And write it
	exx

	rrc	e	;Ink
	ld	a,e
	sbc	a,a	;= 255 if it was set
	and	h
	ld	c,a	;Contains ink green to be set

	rrc	d	;paper
	ld	a,d
	sbc	a,a	;
	and	l
	or	c	;So now we have the green byte

	out	($5d),a	;Switch to red
	exx
	ld	(hl),a	;And write it

	out	($5f),a	;Back to main memory

	inc	de
	ld	bc,80	;Next row
	add	hl,bc
	pop	bc
	djnz	loop
	call	l_pop_ei
	ret

; Entry:
; c = x
; b = y
generic_console_xypos_graphics:
        ld      hl, $c000- 80 * 8
        ld      de, 80 * 8
        inc     b
generic_console_xypos_graphics_1:
        add     hl,de
        djnz    generic_console_xypos_graphics_1
        add     hl,bc
        ret


