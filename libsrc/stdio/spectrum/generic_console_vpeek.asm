	

	MODULE	generic_console_vpeek
	SECTION	code_clib

	PUBLIC	generic_console_vpeek

	EXTERN	generic_console_calc_screen_addr
	EXTERN  screendollar
	EXTERN  screendollar_with_count
	EXTERN	__console_w
	EXTERN	__zx_32col_udgs
	EXTERN	__zx_32col_font
	EXTERN	__zx_64col_font
	EXTERN	__ts2068_hrgmode



generic_console_vpeek:
	ld	hl,-8
	add	hl,sp		;de = screen, hl = buffer, bc = coords
	ld	sp,hl
IF FORts2068
	ld	a,(__ts2068_hrgmode)
	cp	6
	jr	nz,standard_screen
	ld	a,(__console_w)
	cp	128
	jr	z,handle_64col
	jr	continue
standard_screen:
ENDIF
	ld	a,(__console_w)
	cp	32
	jr	nz,handle_64col
continue:
	push	hl		;Save buffer
	ex	de,hl		;get it into de
	call	generic_console_calc_screen_addr
	; Make some space
	ld	b,8
vpeek_1:
	ld	a,(hl)
	ld	(de),a
	inc	h
	inc	de
	djnz 	vpeek_1
	pop	de		;the buffer on the stack
	ld	hl,(__zx_32col_font)
do_screendollar:
	call	screendollar
	jr	nc,gotit
	ld	hl,(__zx_32col_udgs)
	ld	b,128
	call	screendollar_with_count
	jr	c,gotit
	add	128
gotit:
	ex	af,af		; Save those flags
	ld	hl,8		; Dump our temporary buffer
	add	hl,sp
	ld	sp,hl
	ex	af,af		; Flags and parameter back
	ret

handle_64col:
	; hl = buffer
	; bc = coordinates
	push	hl		;save buffer
	ex	de,hl
	srl	c
	ex	af,af		;save flags
	call	generic_console_calc_screen_addr
	;hl = screen
	ex	de,hl		;de = screen, hl=buffer
	ex	af,af
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
