;

		SECTION		code_driver

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_plotc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		conio_map_colour
		EXTERN		generic_console_font32
		EXTERN		generic_console_udg32
		EXTERN		generic_console_flags
		EXTERN		lynx_lores_graphics


		INCLUDE		"target/lynx/def/lynx.def"
		INCLUDE		"ioctl.def"

generic_console_set_attribute:
	ret

generic_console_set_ink:
	call	conio_map_colour
	and	7
	ld	(SYSVAR_inkst),a
	ret

generic_console_set_paper:
	call	conio_map_colour
	and	7
	ld	(SYSVAR_paperst),a
	ret

generic_console_cls:
	call	$8e5		;Clear screen (based on colours)
	; Now clear alt screen
	exx
	ld	a,$5
	ld	bc,$ff7f
	out	(c),a
	exx	
	ld	a,$24
	out	($80),a
	ld	bc,8192
	ld	hl,$a000
cls_loop:
	ld	(hl),0
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,cls_loop
	xor	a
	exx
	out	(c),a
	exx
	out	($80),a
	ret

generic_console_scrollup:
	push	de
	push	bc
	ld	hl,$c100
	ld	b,CONSOLE_ROWS-1
scrollup_1:
	push	bc
	push	hl		;hl = $c000 = red 

	ld	de,scroll_buffer
	call	copy_from_bluered
	pop	de	;Source address
	push	de
	dec	d	;Up a row
	call	copy_to_blue

	pop	hl
	push	hl
	ld	a,h		;hl = $a000 = blue
	sub	$20
	ld	h,a
	ld	de,scroll_buffer
	call	copy_from_bluered
	pop	de		;Source address
	push	de
	ld	a,d
	sub	$21
	ld	d,a
	call	copy_to_blue

	pop	hl	
	push	hl		;hl = $c000 = green
	ld	de,scroll_buffer
	call	copy_from_green
	pop	de	;Source address
	push	de
	dec	d	;Up a row
	call	copy_to_green

	pop	hl
	push	hl
	ld	a,h		;hl = $a000 = alt green
	sub	$20
	ld	h,a
	ld	de,scroll_buffer
	call	copy_from_green
	pop	de		;Source address
	push	de
	ld	a,d
	sub	$21
	ld	d,a
	call	copy_to_green

	pop	hl
	inc	h		;And down a row
	pop	bc
	djnz	scrollup_1

	; TODO: Blanking bottom row - lets print spaces
	ld	e,CONSOLE_COLUMNS
	ld	bc,$1f00
blank_row:
	push	de
	push	bc
	ld	a,' '
	ld	e,0
	call	generic_console_printc
	pop	bc
	inc	c
	pop	de
	dec	e
	jr	nz,blank_row
	pop	bc
	pop	de
	ret


; Copy from the buffer to the screen address
; Entry: de = destination address
copy_to_blue:
	ld	a,$28
	ex	af,af
	ld	a,3	;Red/blue bank
	jr	copy_block

copy_to_green:
	ld	a,$24	;Port 80 value
	ex	af,af
	ld	a,$5	;Green bank
copy_block:
	exx
	ld	bc,$ff7f
	out	(c),a
	exx
	ex	af,af
	out	($80),a
	ld	hl,scroll_buffer
	ld	bc,256
	ldir
	xor	a
	exx	
	out	(c),a
	exx
	out	($80),a
	ret

; Entry: hl = address to copy from
;        de = buffer to copy to
copy_from_green:
	ld	b,0
copy_from_green_1:
	push	bc
	push	hl
	call	INGREEN
	ld	a,l
	ld	(de),a
	pop	hl
	pop	bc
	inc	hl
	inc	de
	djnz	copy_from_green_1
	ret

copy_from_bluered:
	ld	b,0
copy_from_bluered_1:
	push	bc
	push	hl
	call	INBLUE
	ld	a,l
	ld	(de),a
	pop	hl
	pop	bc
	inc	hl
	inc	de
	djnz	copy_from_bluered_1
	ret

; Plot a lores graphics character to the screen
; c = x
; b = y
; a = character to print
generic_console_plotc:
	call	generic_console_xypos		;preserves a
	ex	de,hl		;de = destination
	ld	bc,(lynx_lores_graphics)
	inc	b
	jr	not_udg

; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
	call	generic_console_xypos		;preserves a
	ex	de,hl		;de = destination
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
	dec	h		;-32 characters
	ex	de,hl		;hl=screen, de = font

        ld      a,(generic_console_flags)
        rlca            ;get bit 7 out
        sbc     a
        ld      c,a     ; c = 0/ c = 255
print_a_character:
	; hl = screen
	; de = font
	;  c = mask
	ld	b,8
loop:
	ld	a,(de)
	xor	c
	push	bc
	push	de
	push	hl
	push	af		;Save value
	ld	c,0
	call	OUTB
	pop	af
	pop	hl
	push	hl

	; Now write to the alt green page so we know what's on screen (and can use it for
	; vpeek etc)
	ld	de,$a000	;Where alt-green is located
	add	hl,de
	ld	e,a		;Save e
	exx
	ld	a,$5
	ld	bc,$ff7f
	out	(c),a
	exx	
	ld	a,$24
	out	($80),a
	ld	(hl),e
	xor	a
	exx
	out	(c),a
	exx
	out	($80),a


	pop	hl
	ld	bc,32
	add	hl,bc
	pop	de
	pop	bc
	inc	de
	djnz	loop
	ret

generic_console_xypos:
	ld	h,b		;y * 256
	ld	l,0
	ld	b,0
	add	hl,bc		;Add x
	ret

	SECTION		bss_clib

scroll_buffer:	defs	256
