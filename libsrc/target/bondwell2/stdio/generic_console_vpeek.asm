	

	MODULE		generic_console_vpeek
	SECTION		code_himem

	PUBLIC		generic_console_vpeek

	EXTERN		generic_console_xypos
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
	push	de
	call	swapgfxbk
	call	generic_console_xypos
	pop	de
	ld	b,8
vpeek_1:
	push	bc
	ld	a,(hl)
	ld	(de),a
	inc	de
	ld	bc,80
	add	hl,bc
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

