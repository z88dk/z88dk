; Sony SMC-777 console
;


        SECTION code_clib

        PUBLIC  generic_console_cls
        PUBLIC  generic_console_vpeek
        PUBLIC  generic_console_scrollup
        PUBLIC  generic_console_printc
        PUBLIC  generic_console_set_ink
        PUBLIC  generic_console_set_paper
        PUBLIC  generic_console_set_attribute

	EXTERN	generic_console_flags
	EXTERN	conio_map_colour
	EXTERN	__smc777_mode
	EXTERN	__smc777_attr
	EXTERN	__smc777_ink16
	EXTERN	__smc777_paper16

	EXTERN	CONSOLE_COLUMNS
	EXTERN	CONSOLE_ROWS

generic_console_set_attribute:
	ld	a,(generic_console_flags)
	rrca
	rrca
	and	@00100000
	ld	c,a
	ld	a,(__smc777_attr)
	and	@11011111
set_attr:
	or	c
	ld	(__smc777_attr),a
	ret

generic_console_set_ink:
	call	conio_map_colour
	push	af
	and	7
	ld	c,a
	ld	a,(__smc777_attr)
	and	@11111000
	call	set_attr
	pop	af
	call	nc,rotate	;attribute is in high nibble
	and	15
	ld	(__smc777_ink16),a
	ret

	
generic_console_set_paper:
	call	conio_map_colour
	call	nc,rotate	;colour from table, is in high nibble
	and	15
	ld	(__smc777_paper16),a
	ret

rotate:
	rrca
	rrca
	rrca
	rrca
	ret


generic_console_cls:
	ld	hl, +(CONSOLE_ROWS * CONSOLE_COLUMNS)
	ld	bc, 0
continue:
	ld	a,' '
	out	(c),a
	set	3,c
	ld	a,(__smc777_attr)
	out	(c),a
	res	3,c
	inc	b
	jr	nz,loop
	inc	c
loop:	dec	hl
	ld	a,h
	or	l
	jr	nz,continue
	ld	a,(__smc777_mode)
	and	@00001100
	ret	z
	cp	@00001000
	jr	z,get_bgattr_640
	call	get_bgattr_320
clg:
	ld	bc,$0080
clg_1:
	out	(c),l
	inc	b
	jr	nz,clg_1
	inc	c
	jr	nz,clg_1
	ret

get_bgattr_320:
	ld	a,(__smc777_paper16)
	and	@00001111
	ld	l,a
	rlca
	rlca
	rlca
	rlca
	or	l
	ld	l,a
	ret

get_bgattr_640:
	ld	a,(__smc777_paper16)
	and	@00000011
	ld	l,a
	rlca
	rlca
	or	l
	rlca
	rlca
	or	l
	rlca
	rlca
	or	l
	ld	l,a
	jr	clg


; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	call	xypos
	out	(c),a
	set	3,c
	ld	a,(__smc777_attr)
	out	(c),a
	ret


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        call    xypos
	in	a,(c)
        and     a
        ret


xypos:
	ld	hl,-CONSOLE_COLUMNS
	ld	de,CONSOLE_COLUMNS
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	ex	af,af
	ld	a,(__smc777_mode)
	and	@00000011
	jr	z,is_80_col
	add	hl,bc
is_80_col:
	ex	af,af
	ld	c,h			;And swap round
	ld	b,l
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	bc, +(CONSOLE_COLUMNS * 256)
	ld	hl,+((CONSOLE_ROWS -1)* CONSOLE_COLUMNS)
scroll_loop:
	push	hl
	push	bc
	in	e,(c)
	set	3,c
	in	d,(c)
	ld	l,b
	ld	h,c
	ld	bc,-CONSOLE_COLUMNS
	add	hl,bc
	ld	c,h
	ld	b,l
	out	(c),d
	res	3,c
	out	(c),e
	pop	bc
	inc	b
	jr	nz,scroll_continue
	inc	c
scroll_continue:
	pop	hl
	dec	hl
	ld	a,h
	or	l
	jr	nz,scroll_loop


	ld	bc,$8007		;Row 25, column 0
	ld	e,CONSOLE_COLUMNS
	ld	d,' '
	ld	a,(__smc777_attr)
scroll_loop_2:
	out	(c),d
	set	3,c
	out	(c),a
	res	3,c
	inc	b
	jr	nz,clear_continue
	inc	c
clear_continue:
	dec	e
	jr	nz,scroll_loop_2
	pop	bc
	pop	de
	ret



	SECTION	code_crt_init

        EXTERN  asm_set_cursor_state
	EXTERN	copy_font_8x8
	EXTERN	CRT_FONT

        ld      l,$20
        call    asm_set_cursor_state
	ld	bc,$1000 + (32 * 8)
	ld	e,96
	ld	hl,CRT_FONT
	ld	a,h
	or	l
	call	nz,copy_font_8x8
