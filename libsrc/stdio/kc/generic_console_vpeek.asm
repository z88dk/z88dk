

	MODULE	generic_console_vpeek
	SECTION	code_clib
	PUBLIC	generic_console_vpeek

	EXTERN	generic_console_xypos
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32
	EXTERN	screendollar
	EXTERN	screendollar_with_count

generic_console_vpeek:
	call	generic_console_xypos
	ex	de,hl
	ld	hl,-8
	add	hl,sp
	ld	sp,hl
	push	hl		;save buffer
	ex	de,hl
	; hl = screen address
	; de = buffer
	push	hl
	call	dohalf
	pop	hl
	ld	bc,$20
	add	hl,bc
	call	dohalf
	pop	de		;buffer
	ld	hl,(generic_console_font32)
	call	screendollar
	jr	nc,gotit
	ld	hl,(generic_console_udg32)
	ld	b,128
	call	screendollar_with_count
	jr	c,gotit
	add	128
gotit:
	ex	af,af
	ld	hl,8
	add	hl,sp
	ld	sp,hl
	ex	af,af
        ret

dohalf:
	ld	b,4
loop1:
	push	bc
	ld	a,(hl)
	ld	(de),a
	inc	de
	ld	bc,$80
	add	hl,bc
	pop	bc	
	djnz	loop1
	ret
