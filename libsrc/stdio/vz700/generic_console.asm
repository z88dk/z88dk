

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		conio_map_colour
		EXTERN		generic_console_flags

		INCLUDE		"target/vz700/def/vz700.def"
		defc		DISPLAY = 0xf800 - 0x8000

generic_console_ioctl:
	scf
generic_console_set_inverse:
	ret

generic_console_set_paper:
	call	conio_map_colour
	and	15
	ld	b,a
	ld	a,(attr)
	and	0xf0
	or	b
	ld	(attr),a
	ret

generic_console_set_ink:
	call	conio_map_colour
	and	15
	rlca
	rlca
	rlca
	rlca
	ld	b,a
	ld	a,(attr)
	and	0x0f
	or	b
	ld	(attr),a
	ret

	

generic_console_cls:
	ld	a,(SYSVAR_bank1)
	push	af
	ld	a,7
	ld	(SYSVAR_bank1),a
	out	($41),a
	ld	hl, DISPLAY
	ld	bc, 2032 / 2
	ld	de,(attr)
	ld	d,32
loop:
	ld	(hl),d
	inc	hl
	ld	(hl),e
	inc	hl
	dec	bc	
	ld	a,b
	or	c
	jr	nz,loop
	pop	af
	ld	(SYSVAR_bank1),a
	out	($41),a
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	ex	af,af
	ld	a,(SYSVAR_bank1)
	push	af
	ld	a,7
	ld	(SYSVAR_bank1),a
	out	($41),a
	ex	af,af
	call	xypos
	ld	d,a		;Save character
	ld	a,(generic_console_flags)
	and	128		;bit 7 = inverse
	or	d
	ld	(hl),a
	inc	hl
	ld	a,(attr)
	ld	(hl),a
	pop	af
	ld	(SYSVAR_bank1),a
	out	($41),a
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	ld	a,(SYSVAR_bank1)
	push	af
	ld	a,7
	ld	(SYSVAR_bank1),a
	out	($41),a
        call    xypos
	ld	a,(hl)
	and	127		;Remove inverse flag
	ex	af,af
	pop	af
	ld	(SYSVAR_bank1),a
	out	($41),a
	ex	af,af
	ret


xypos:
	push	af
	ld	a,b		; Modulus 8 
	and	7
	ld	h,a		;*256

	ld	l,0
	srl	b		;y/ 8
	srl	b
	srl	b
	ld	de,80
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
	and	a		;We went one row too far
	sbc	hl,de
generic_console_printc_3:
	add	hl,bc	
	add	hl,bc			;hl now points to address in display
	ld	bc,DISPLAY
	add	hl,bc
	pop	af
	ret



generic_console_scrollup:
	ld	a,(SYSVAR_bank1)
	push	af
	ld	a,7
	ld	(SYSVAR_bank1),a
	out	($41),a

	push	de
	push	bc
	ld	a,23
	ld	bc, $0000
scrollup_1:
	push	af
	push	bc
	call	xypos
	pop	bc
	push	bc
	push	hl		;dest
	inc	b
	call	xypos		;hl=source
	pop	de
	ld	bc,80
	ldir
	pop	bc
	inc	b
	pop	af
	dec	a
	jr	nz,scrollup_1
	ld	a,CONSOLE_COLUMNS
	ld	bc,$1700	;Last row
scrollup_2:
	push	af
	push	bc
	ld	a,' '
	ld	e,0
	call	generic_console_printc
	pop	bc
	inc	c
	pop	af
	dec	a
	jr	nz,scrollup_2

	pop	bc
	pop	de

	pop	af
	ld	(SYSVAR_bank1),a
	out	($41),a
	ret

	SECTION	bss_clib

attr:	defb	0x07
