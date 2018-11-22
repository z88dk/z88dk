
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
loop:
	ld	a,(de)		;pick up font form main memory
	xor	c
	push	bc
	push	de
	ld	b,a		;save byte

	ld	de,(__pc88_ink)
	
	rrc	e	;Ink
	ld	a,e
	sbc	a,a	;= 255 if it was set
	and	b
	ld	c,a	;Contains ink blue to be set
IF 0
	rrc	d	;paper
	ld	a,d
	rlca		;bit 0 = green bit
	sbc	a,a	;
	cpl		;0 if set, 255 if not set
	xor	b	;a = bits to be set for green paper
	or	c	;So now we have the blue byte
ENDIF

	out	($5c),a	;Switch to blue
	ld	(hl),a	;And write it

	rrc	e	;Ink
	ld	a,e
	sbc	a,a	;= 255 if it was set
	and	b
	ld	c,a	;Contains ink green to be set
IF 0
	rrc	d	;paper
	ld	a,d
	rlca		;bit 0 = green bit
	sbc	a,a	;
	cpl		;0 if set, 255 if not set
	xor	b	;a = bits to be set for green paper
	or	c	;So now we have the green byte
ENDIF

	out	($5e),a	;Switch to green
	ld	(hl),a	;And write it

	rrc	e	;Ink
	ld	a,e
	sbc	a,a	;= 255 if it was set
	and	b
	ld	c,a	;Contains ink green to be set

IF 0
	rrc	d	;paper
	ld	a,d
	rlca		;bit 0 = green bit
	sbc	a,a	;
	cpl		;0 if set, 255 if not set
	xor	b	;a = bits to be set for green paper
	or	c	;So now we have the green byte
ENDIF

	out	($5d),a	;Switch to red
	ld	(hl),a	;And write it

	out	($5f),a	;Back to main memory

	pop	de	;Get font address back
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


