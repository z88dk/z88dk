;
; Generic console that maps into VT52 terminal codes
;
; We maintain a "back screen" so that vpeek will work
; 


	MODULE		generic_console_vt52
	SECTION		code_clib

	PUBLIC		generic_console_cls_vt52
	PUBLIC		generic_console_vpeek_vt52
	PUBLIC		generic_console_scrollup_vt52
	PUBLIC		generic_console_printc_vt52
	PUBLIC		generic_console_ioctl_vt52
    PUBLIC      generic_console_set_ink_vt52
    PUBLIC      generic_console_set_paper_vt52
    PUBLIC      generic_console_set_attribute_vt52

	EXTERN		CONSOLE_COLUMNS
	EXTERN		CONSOLE_ROWS
	EXTERN		__bdos

	INCLUDE		"ioctl.def"
	PUBLIC      CLIB_GENCON_CAPS
	defc        CLIB_GENCON_CAPS = 0

generic_console_ioctl_vt52:
	scf
generic_console_set_attribute_vt52:
	ret

generic_console_set_ink_vt52:
	ret

generic_console_set_paper_vt52:
	ret

generic_console_cls_vt52:
	ld	hl,screen_copy
	ld	de,screen_copy+1
	ld	bc,+(CONSOLE_ROWS * CONSOLE_COLUMNS) - 1
	ld	(hl),0
	ldir
	ld	e,$1A		;clear screen/home cursor
	ld	c,2
	call	__bdos
	ret

generic_console_scrollup_vt52:
	push	de
	push	bc
	ld	hl,screen_copy + CONSOLE_COLUMNS
	ld	de,screen_copy
	ld	bc,+((CONSOLE_ROWS-1) * CONSOLE_COLUMNS)
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
cls_1:
	ld	(hl),32
	inc	hl
	djnz	cls_1
	ld	e,10
	ld	c,2
	call	__bdos
	ld	e,13
	ld	c,2
	call	__bdos
	pop	bc
	pop	hl
	ret

; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc_vt52:
	push	bc
	push	af
	call	xypos
	ld	(hl),a
	pop	af
	pop	bc
	ld	hl,prchar_char
	ld	(hl),a
	dec	hl
	ld	a,c
	add	32
	ld	(hl),a
	dec	hl
	ld	a,b
	add	32
	ld	(hl),a
	; And now print the message
	ld	hl,prchar
loop:
	ld	a,(hl)
	cp	255
	ret	z
	push	hl
	ld	e,a
	ld	c,2
	call	__bdos
	pop	hl
	inc	hl
	jr	loop

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek_vt52:
	call	xypos
	ld	a,(hl)
	and	a
	ret

xypos:
    ld      hl,screen_copy - CONSOLE_COLUMNS
    ld      de,CONSOLE_COLUMNS
    inc     b
generic_console_printc_1:
    add     hl,de
    djnz    generic_console_printc_1
generic_console_printc_3:
    add     hl,bc                   ;hl now points to address in display
    ret

	SECTION	data_clib

prchar:
	defb	27
	defb	'Y'
	defb	0
	defb	0
prchar_char:
	defb	0
	defb	255


	SECTION	bss_clib

screen_copy:	
	defs	80 * 25		;Hopefully big enough?


