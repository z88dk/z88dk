	

	MODULE	generic_console_vpeek
	SECTION	code_clib

	PUBLIC	generic_console_vpeek

	EXTERN	generic_console_calc_screen_addr
	EXTERN  screendollar
	EXTERN	__console_w
	EXTERN	__zx_32col_font
	EXTERN	__zx_64col_font



generic_console_vpeek:
	push	bc
	call	generic_console_calc_screen_addr
	pop	bc
	ex	de,hl
	ld	hl,-8
	add	hl,sp		;de = screen, hl = buffer, bc = coords
	ld	a,(__console_w)
	cp	32
	jr	nz,handle_64col
	; Make some space
	push	hl		;Save buffer
	ld	b,8
vpeek_1:
	ld	a,(de)
	ld	(hl),a
	inc	d
	inc	hl
	djnz 	vpeek_1
	pop	de		;the buffer on the stack
	ld	hl,(__zx_32col_font)
do_screendollar:
	call	screendollar
	ex	af,af		; Save those flags
	ld	hl,8		; Dump our temporary buffer
	add	hl,sp
	ex	af,af		; Flags and parameter back
	ret

handle_64col:
	; hl = buffer
	; de = screen
	; bc = coordinates
	push	hl		;save buffer
	rr	c
	ld	c,0xf0
	jr	nc,even_column
	ld	c,0x0f
even_column:
	ld	b,8
vpeek_2:
	ld	a,(de)
	and	c
	ld	(hl),a
	rrca
	rrca
	rrca
	rrca
	or	(hl)
	ld	(hl),a
	inc	hl
	inc	d
	djnz	vpeek_2
	pop	de		;buffer
	ld	hl,(__zx_64col_font)
	jr	do_screendollar
