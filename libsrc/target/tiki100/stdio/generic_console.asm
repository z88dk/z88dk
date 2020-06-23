

	SECTION		code_himem

	PUBLIC		generic_console_printc
	PUBLIC		generic_console_scrollup
	PUBLIC		generic_console_xypos

	EXTERN		generic_console_font32
	EXTERN		generic_console_udg32
	EXTERN		generic_console_flags
	EXTERN		generic_console_get_mode
	EXTERN		__console_w

	EXTERN		__MODE2_attr
	EXTERN		__MODE3_attr


		EXTERN		gr_setpalette
		EXTERN		gr_vscroll
		EXTERN		swapgfxbk
		EXTERN		swapgfxbk1

		defc 		SCREEN_LAST_ROW = $7c00

		INCLUDE		"target/cpm/def/tiki100.def"


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
	rlca	
	sbc	a
	ld	c,a
	call	swapgfxbk
	call	generic_console_get_mode
	ex	af,af
	ld	b,8
printc_1:
	push	bc
	ld	a,(de)
	xor	c
	; Bits are mirrored
	ld	 c,a
	rlca
	rlca
	xor	c
	and	0xaa
	xor	c
	ld	 c,a
	rlca
	rlca
	rlca
	rrc	c
	xor	c
	and	0x66
	xor	c
	ex	af,af
	cp	1
	call	z,printc_MODE1
	cp	2	
	call	z,printc_MODE2
	cp	3
	call	z,printc_MODE3
	ex	af,af
	inc	de
	pop	bc	
	djnz	printc_1
printc_cleanup:
	call	swapgfxbk1
	; And cleanup the buffer
	ld	hl,8
	add	hl,sp
	ld	sp,hl
	ret

printc_MODE1:
	ex	af,af
	ld	(hl),a
	ld	bc,128
	add	hl,bc
	ex	af,af
	ret

; hl = screen
; a' = bytes to print
; 2 pixels on screen
printc_MODE2:
	ex	af,af
	push	de
	ld	b,2
printc_MODE2_0:
	push	bc
	push	hl
	ld	de,(__MODE2_attr)	;e = ink, d = paper - high bits
	ld	l,a
	ld	b,4
	ld	c,0			;Final attribute
printc_MODE2_1:
	rr	l
	ld	a,d
	jr	nc,is_paper
	ld	a,e
is_paper:
	or	c
	ld	c,a
	sla	d
	sla	d
	sla	e
	sla	e
	djnz	printc_MODE2_1
	ld	a,l			;Save what's left of the character
	pop	hl
	ld	(hl),c
	inc	hl
	pop	bc
	djnz	printc_MODE2_0
	ld	bc,126
	add	hl,bc
	pop	de
	ex	af,af
	ret

printc_MODE3:
	ex	af,af
	push	de

	ld	b,4
printc_MODE3_0:
	ld	de,(__MODE3_attr)
	push	bc
	push	hl
	ld	l,a
	ld	b,2
	ld	c,0			;final attribute
printc_MODE3_1:
	rr	l
	ld	a,d
	jr	nc,is_paper_MODE3
	ld	a,e
is_paper_MODE3:
	or	c
	ld	c,a
	; Yuck
	sla	d
	sla	d
	sla	d
	sla	d
	sla	e
	sla	e
	sla	e
	sla	e
	djnz	printc_MODE3_1
	ld	a,l
	pop	hl
	ld	(hl),c
	inc	hl
	pop	bc
	djnz	printc_MODE3_0
	ld	bc,124
	add	hl,bc
	pop	de
	ex	af,af
	ret






generic_console_xypos:
	; Each character row is 128 x 8 bytes
	push	af
	ld	h,b			;x256
	ld	l,0	
	add	hl,hl			;x512
	add	hl,hl			;x1024
	call	generic_console_get_mode
	dec	a
	jr	z,done			;mode 1, 1024x256x2
	sla	c
	dec	a
	jr	z,done			;mode 2, 512x256x4
	sla	c			;mode 3, 256x256x16
done:
	ld	b,0
	add	hl,bc
	pop	af
	ret
	


generic_console_scrollup:
	push	bc
	push	de
	ld	a,-8
 	call	gr_vscroll
	call	swapgfxbk
	ld	hl,SCREEN_LAST_ROW
	ld	de,SCREEN_LAST_ROW+1
	ld	(hl),0
	ld	bc,1023
	ldir
	call	swapgfxbk1
	pop	de
	pop	bc
	ret


