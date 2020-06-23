	

	MODULE		generic_console_vpeek
	SECTION		code_graphics

	PUBLIC		generic_console_vpeek

	EXTERN		generic_console_xypos
	EXTERN		generic_console_get_mode
	EXTERN		screendollar
	EXTERN		screendollar_with_count
	EXTERN		swapgfxbk
	EXTERN		swapgfxbk1

	EXTERN		generic_console_font32
	EXTERN		generic_console_udg32



generic_console_vpeek:
	ld	hl,-8
	add	hl,sp			;de = screen, hl = buffer, bc = coords
	ld	sp,hl
	push	hl			;Save buffer
	ex	de,hl			;get it into de
	call	swapgfxbk
	call	generic_console_xypos
	call	generic_console_get_mode
	ex	af,af
	ld	b,8
vpeek_1:
	push	bc
	ex	af,af
	cp	1
	call	z,vpeek_MODE1
	cp	2
	call	z,vpeek_MODE2
	cp	3
	call	z,vpeek_MODE3
	ex	af,af
	; And mirror it
	ld	c,a
	rlca
	rlca
	xor	 c
	and	 0xaa
	xor	 c
	ld	c,a
	rlca
	rlca
	rlca
	rrc	 c
	xor	 c
	and	 0x66
	xor	 c
	ld	(de),a
	inc	de
	pop	bc
	djnz 	vpeek_1
	call	swapgfxbk1
	pop	de			;the buffer on the stack
	ld	hl,(generic_console_font32)
do_screendollar:
	call	screendollar
	jr	nc,gotit
	ld	hl,(generic_console_udg32)
	ld	b,128
	call	screendollar_with_count
	jr	c,gotit
	add	128
gotit:
	ex	af,af			; Save those flags
	ld	hl,8			; Dump our temporary buffer
	add	hl,sp
	ld	sp,hl
	ex	af,af			; Flags and parameter back
	ret

vpeek_MODE1:
	ex	af,af
	ld	a,(hl)
	ld	bc,128	
	add	hl,bc
	ex	af,af
	ret

vpeek_MODE2:
	ex	af,af
	push	de
	ld	d,@00000001
	ld	c,0			;resulting byte
	ld	a,2 			;Loop twice
MODE2_nibble:
	push	af
	ld	e,@00000011
	ld	b,4			;4 pixels in a byte
MODE2_1:
	ld	a,(hl)
	and	e
	jr	z,not_set
	ld	a,c
	or	d
	ld	c,a
not_set:
	sla	d
	sla	e
	sla	e
	djnz	MODE2_1
	inc	hl
	pop	af
	dec	a
	jr	nz,MODE2_nibble
	ld	a,c			;Byte to return
	ld	bc,126
	add	hl,bc
	pop	de
	ex	af,af
	ret

vpeek_MODE3:
	ex	af,af
	push	de
	ld	c,0			;resulting byte
	ld	d,@00000001	
	ld	b,4
vpeek_MODE3_0:
	ld	a,(hl)
	and	15
	jr	z,right_nibble
	ld	a,c
	or	d
	ld	c,a
right_nibble:
	sla	d
	ld	a,(hl)
	and	240
	jr	z,vpeek_MODE3_loop
	ld	a,c
	or	d
	ld	c,a
vpeek_MODE3_loop:
	sla	d
	inc	hl
	djnz	vpeek_MODE3_0
	ld	a,c
	ld	bc,124
	add	hl,bc
	pop	de
	ex	af,af
	ret
