

	SECTION		code_himem

	PUBLIC		generic_console_printc
	PUBLIC		generic_console_scrollup
	PUBLIC		generic_console_xypos
	PUBLIC		generic_console_set_ink
	PUBLIC		generic_console_set_paper
	PUBLIC		generic_console_set_attribute

	EXTERN		generic_console_font32
	EXTERN		generic_console_udg32
	EXTERN		generic_console_flags

	EXTERN		swapgfxbk
	EXTERN		swapgfxbk1



generic_console_set_ink:
generic_console_set_paper:
generic_console_set_attribute:
        ret




; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
	ld	hl,-8
	add	hl,sp
	ld	sp,hl
	push	hl		;buffer
	ld	de,(generic_console_font32)
	bit	7,a
	jr	z,not_udg
	and	127
	ld	de,(generic_console_udg32)
	inc	d
not_udg:
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,de
	dec	h			;hl = font
	pop	de			;de = stack buffer
	push	de
	push	bc
	ld	bc,8
	ldir
	pop	bc
	call	generic_console_xypos	;hl = screenposition
	pop	de			;de = character buffer
	ld	a,(generic_console_flags)
	exx	
	ld	h,a
	exx
	rlca	
	sbc	a
	ld	c,a
	call	swapgfxbk
	ld	b,8
	exx
	bit	3,h	;underline
	exx
	jr	z,printc_1
	dec	b	;Underline enabled, only print 7 lines of char
printc_1:
	push	bc
	exx	
	bit	4,h
	exx
	ld	a,(de)
	jr	z,no_bold
	ld	b,a
	rrca
	or	b
no_bold:
	xor	c
	ld	(hl),a
	inc	de
	; Step to next pixel row
	ld	bc,80
	add	hl,bc
	pop	bc
	djnz	printc_1
printc_cleanup:
	exx
	bit	3,h
	exx
	jr	z,no_underline
	ld	(hl),255
no_underline:
	call	swapgfxbk1
	; And cleanup the buffer
	ld	hl,8
	add	hl,sp
	ld	sp,hl
	ret




; c = x
; b = y
generic_console_xypos:
	; Each character row is 80 x 8 bytes
	ld	h,b			;x256
	ld	l,0	
	add	hl,hl			;x512
	ld	d,b			;x128
	ld	e,0
	srl	d
	rr	e
	add	hl,de			;x640
	ld	b,0			;Add column
	add	hl,bc
	ret
	


generic_console_scrollup:
	push	bc
	push	de
	call	swapgfxbk
	ld	hl,8*80
	ld	de,0
	ld	bc,192* 80
	ldir
	ld	hl,192 * 80
	ld	de,+(192 * 80) + 1
	ld	(hl),0
	ld	bc,639
	ldir
	call	swapgfxbk1
	pop	de
	pop	bc
	ret
