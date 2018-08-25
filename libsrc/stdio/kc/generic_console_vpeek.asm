

	MODULE	generic_console_vpeek
	SECTION	code_clib
	PUBLIC	generic_console_vpeek

	EXTERN	generic_console_xypos
	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32
	EXTERN	screendollar
	EXTERN	screendollar_with_count
	EXTERN	kc_type

vpeek_85_4:
	ld	a,(iy+1)
	res	1,a
	ld	(iy+1),a
	out	($84),a
	; hl = screen address
	; de = buffer
	ld	b,8
vpeek_85_4_1:
	ld	a,(hl)
	ld	(de),a
	inc	l
	inc	de
	djnz	vpeek_85_4_1
	jr	vpeek_rejoin

generic_console_vpeek:
	call	generic_console_xypos
	ex	de,hl
	ld	hl,-8
	add	hl,sp
	ld	sp,hl
	push	hl		;save buffer
	ex	de,hl

        in      a,($88)
        push    af              ;Save value
        set	2,a             ;Page video in
        out     ($88),a
	ld	a,(kc_type)
	and	a
	jr	nz,vpeek_85_4

	; hl = screen address
	; de = buffer
	push	hl
	call	dohalf
	pop	hl
	ld	bc,$20
	add	hl,bc
	call	dohalf

vpeek_rejoin:
	pop	af
	out	($88),a		;page video out

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
