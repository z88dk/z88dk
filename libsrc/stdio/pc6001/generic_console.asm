
		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse
		PUBLIC		generic_console_text_xypos

		PUBLIC		__pc6001_attr

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		EXTERN		__pc6001_mode
		EXTERN		generic_console_font32
		EXTERN		generic_console_udg32
		EXTERN		generic_console_flags

		; PC6001 - DISPLAY = $8200, COLOUR = $8000
		; PC6001mk2 - DISPLAY = $c200, COLOUR = $c000 (also unexpanded 6001)

		INCLUDE		"target/pc6001/def/pc6001.def"

generic_console_set_inverse:
	ld	a,(hl)
	ld	c,0
	rlca
	rl	c
	ld	a,(__pc6001_attr)
	and	254
	or	c
	ld	(__pc6001_attr),a
	ret

generic_console_set_ink:
	rrca
	rrca
	and	@11000000
	ld	(attr_mode2),a
	ret

	
generic_console_set_paper:
	rrca
	rrca
	and	@11000000
	ld	(attr_mode2+1),a
	ret

generic_console_cls:
	ld	hl,(SYSVAR_screen - 1)
	ld	a,(__pc6001_mode)
	and	a
	jr	z,cls_text
	ld	l,0
	; NecTrek needs all characters setting
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,512
	ld	(hl),a		; TODO, Border colour is in here somewhere
	ldir
	ld	bc,6143
	ld	(hl),0
	ldir
	ret
cls_text:
	inc	h
	inc	h
	ld	l,0
	ld	d,h
	ld	e,1
	push	hl
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	(hl),32
	ldir
	pop	hl
	dec	h
	dec	h
	ld	d,h
	ld	e,1
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	a,(__pc6001_attr)
	ld	(hl),a
	ldir
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	ex	af,af
	ld	a,(__pc6001_mode)
	and	a
	jr	z,printc_text
	jr	printc_hires

printc_text:
	ex	af,af
	call	generic_console_text_xypos
	ld	(hl),a
	dec	h
	dec	h
	ld	a,(__pc6001_attr)
	ld	(hl),a
	ret

printc_hires:
	ld	l,d
	ld	h,0
	ld	de,(generic_console_font32)
	bit	7,l
	jr	z,not_udg
	res	7,l
	ld	de,(generic_console_udg32)
	inc	d
not_udg:
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,de
	dec	h
	ex	de,hl		;de = font
	cp	MODE_1
	jr	z,print_hires
	cp	MODE_2
	ret	nz

; Printing in mode 2 - semi hires mode
;
; p0-b0 p0-b1 p1-b0 p1-b1 p2-b0 p2-b1 p3-b0 p3-b1
	ld	h,b		;32 * 8
	ld	l,c
	ld	bc,(SYSVAR_screen - 1)
	ld	c,l
	add	hl,bc
	inc	h
	inc	h		;hl = screen address
        ld      a,(generic_console_flags)
        rlca
        sbc     a,a
        ld      c,a             ;x = 0 / 255
        ld      b,8
semihires_1:
	push	bc
	ld	a,(de)
	xor	c
	push	de
	ld	b,2
semihires_2:
	ld	de,(attr_mode2)
	push	bc
	push	hl
	ld	l,a
	ld	b,4
	ld	c,0	;final attribute
semihires_3:
	rl	l
	ld	a,d
	jr	nc,is_paper
	ld	a,e
is_paper:
	or	c
	ld	c,a
	srl	d
	srl	d
	srl	e
	srl	e
	djnz	semihires_3
	ld	a,l		;save what's left of character
	pop	hl
	ld	(hl),c
	inc	hl
	pop	bc
	djnz	semihires_2
	ld	de,30
	add	hl,de
	pop	de
	inc	de
	pop	bc
	djnz	semihires_1
	ret


print_hires:
	ld	h,b		;32 * 8
	ld	l,c
	ld	bc,(SYSVAR_screen - 1)
	ld	c,0
	add	hl,bc
	inc	h
	inc	h		;hl = screen address
        ld      a,(generic_console_flags)
        rlca
        sbc     a,a
        ld      c,a             ;x = 0 / 255
        ld      b,8
hires_printc_1:
	ld	a,(de)
	xor	c
	ld	(hl),a
	inc	de
	ld	a,l
	add	32
	ld	l,a
	jr	nc,no_overflow
	inc	h
no_overflow:
	djnz	hires_printc_1
	ret




generic_console_text_xypos:
	push	af
	ld	l,b
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld	a,(SYSVAR_screen)
	inc	a
	inc	a
	ld	b,a
	add	hl,bc
	pop	af
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	a,(__pc6001_mode)
	and	a
	jr	z,scrollup_text
	cp	MODE_1
	jr	z,scrollup_hires
	cp	MODE_2
	jr	z,scrollup_hires	;possibly wrong
	pop	bc
	pop	de
	ret


scrollup_text:
	ld	hl,(SYSVAR_screen - 1)
	inc	h
	inc	h
	ld	l, CONSOLE_COLUMNS
	ld	d,h
	ld	e,0
	push	hl	; Save start of screen
	ld	bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	pop	hl		;Get screen back
	dec	h
	dec	h
	ld	d,h
	ld	e,0
	ld	bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
	ld	a,(__pc6001_attr)
generic_console_scrollup_4:
	ld	(hl),a
	inc	hl
	djnz	generic_console_scrollup_4
	pop	bc
	pop	de
	ret

scrollup_hires:
	ld	hl,(SYSVAR_screen - 1)
	inc	h
	inc	h
	ld	l,0
	ld	d,h
	ld	e,l
	inc	h
	ld	bc,32 * 184
	ldir
	ex	de,hl
	ld	b,0
	xor	a
scrollup_hires_1:
	ld	(hl),a
	djnz	scrollup_hires_1
	pop	bc
	pop	de
	ret



	SECTION data_clib

__pc6001_attr:	defb	32		;We use the external character generator
attr_mode2:	defb	@11000000,@00000000
