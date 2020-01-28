

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute
		PUBLIC		__laser500_mode
		PUBLIC		__laser500_attr

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		__console_w
		EXTERN		conio_map_colour
		EXTERN		generic_console_flags
		EXTERN		generic_console_font32
		EXTERN		generic_console_udg32
		EXTERN		generic_console_xypos
                EXTERN          screendollar
                EXTERN          screendollar_with_count

		INCLUDE		"target/laser500/def/laser500.def"
		defc		DISPLAY = 0xf800 - 0x8000

generic_console_set_attribute:
	ret

generic_console_set_paper:
	call	conio_map_colour
	and	15
	ld	b,a
	ld	a,(__laser500_attr)
	and	0xf0
	or	b
	ld	(__laser500_attr),a
	ret

generic_console_set_ink:
	call	conio_map_colour
	and	15
	rlca
	rlca
	rlca
	rlca
	ld	b,a
	ld	a,(__laser500_attr)
	and	0x0f
	or	b
	ld	(__laser500_attr),a
	ret

	

generic_console_cls:
	ld	a,(SYSVAR_bank1)
	push	af
	ld	a,7
	ld	(SYSVAR_bank1),a
	out	($41),a
	ld	a,(__laser500_mode)
	cp	2
	jr	z,cls_hires
	ld	hl, DISPLAY
	ld	bc,+( 2032 / 2)
	ld	de,(__laser500_attr)
        ld      a,e
        out     ($45),a         ;set 80 column colour
	ld	d,32
	ld	a,(__laser500_mode)
	and	a
	jr	z,loop
	ld	e,d		;80 column, need spaces
loop:
	ld	(hl),d
	inc	hl
	ld	(hl),e
	inc	hl
	dec	bc	
	ld	a,b
	or	c
	jr	nz,loop
cls_return:
	pop	af
	ld	(SYSVAR_bank1),a
	out	($41),a
	ret

cls_hires:
	ld	bc, 8192
	ld	hl, 16384
	ld	de,(__laser500_attr)
	ld	d,0
cls_hires_loop:
	ld	(hl),d
	inc	hl
	ld	(hl),e
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,cls_hires_loop
	jr	cls_return

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
	call	generic_console_xypos		
	ld	d,a		;Save character
	ld	a,(__laser500_mode)
	cp	2
	jr	z,printc_hires
	ld	a,(generic_console_flags)
	and	128		;bit 7 = inverse
	or	d
	ld	d,a
	ld	a,(__laser500_mode)
	and	a
	jr	z,text_40col_printc
	ld	(hl),d		;80 column mode, no __laser500_attributes
	jr	printc_return
text_40col_printc:
	add	hl,bc		;40 column mode, we have __laser500_attribtues
	ld	(hl),d
	inc	hl
	ld	a,(__laser500_attr)
	ld	(hl),a
printc_return:
	pop	af
	ld	(SYSVAR_bank1),a
	out	($41),a
	ret

printc_hires:
	add	hl,bc		;We need to get 40 column offset
	ld	a,d
	ex	de,hl		;de = screen
	ld	bc,(generic_console_font32)
	bit	7,a
	jr	z,not_udg
	ld	bc,(generic_console_udg32)
	res	7,a
	inc	b
not_udg:
	ld	l,a
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,bc
	dec	h
	ex	de,hl		;hl = screen, de = font
	ld	a,(generic_console_flags)
	rlca
	sbc	a
	ld	c,a		;c = 0 / c = 255
	ld	b,8
printc_hires_loop:
	push	bc
	ld	a,(generic_console_flags)
	bit	4,a
	ld	a,(de)
	ld	b,a
	jr	z,not_bold
	rrca
	or	b
not_bold:
	xor	c
	; Display is morrored, so mirror the byte
	ld	c,a
        rlca
        rlca
        xor     c
        and     0xaa
        xor     c
        ld      c,a
        rlca
        rlca
        rlca
        rrc     c
        xor     c
        and     0x66
        xor     c
	ld	(hl),a
	inc	hl
	ld	a,(__laser500_attr)
	ld	(hl),a
	inc	de
	ld	bc,$800 - 1
	add	hl,bc
	pop	bc
	djnz	printc_hires_loop
	ld	a,(generic_console_flags)
	bit	3,a
	jr	z,printc_return
	ld	bc,-$800
	add	hl,bc
	ld	(hl),255
	jr	printc_return



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
	call	generic_console_xypos
	pop	bc
	push	bc
	push	hl		;dest
	inc	b
	call	generic_console_xypos		;hl=source
	pop	de

	; For hires we need to copy 8 rows..
	ld	b,1
	ld	a,(__laser500_mode)
	cp	2
	jr	nz,mode_0_1
	ld	b,8

mode_0_1:
	ld	a,b
scroll_loop:
	push	hl
	push	de
	ld	bc,80
	ldir
	pop	hl
	ld	bc,$800
	add	hl,bc
	ex	de,hl
	pop	hl
	add	hl,bc
	dec	a
	jr	nz,scroll_loop

	pop	bc
	inc	b
	pop	af
	dec	a
	jr	nz,scrollup_1
	ld	a,(__console_w)
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

scrollup_return:
	pop	bc
	pop	de
	pop	af
	ld	(SYSVAR_bank1),a
	out	($41),a
	ret

scrollup_hires:
	jr	scrollup_return

	SECTION bss_clib

__laser500_mode:	defb	0

	SECTION data_clib

__laser500_attr:	defb	0xf0

