; KC Driver
;
; We need to be low in memory or we might get paged out
;
; The screen layout is "interesting" to say the least on the KC machines
;

		SECTION		driver_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse
		PUBLIC		generic_console_xypos
		PUBLIC		kc_attr

		EXTERN		conio_map_colour
	        EXTERN          generic_console_udg32
       		EXTERN          generic_console_font32
        	EXTERN          generic_console_flags
		EXTERN		generic_console_w
		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		l_jphl

		INCLUDE		"target/kc/def/caos.def"

generic_console_set_ink:
	call	conio_map_colour
	rlca
	rlca
	rlca
	and	@01111000
	ld	b,@10000111
set_attr:
	ld	c,a
	ld	hl,kc_attr
	ld	a,(hl)
	and	b
	or	c
	ld	(hl),a
generic_console_set_inverse:
	ret

generic_console_set_paper:
	call	conio_map_colour
	and	7
	ld	b,@11111000
	jr	set_attr
	

	ret


generic_console_cls:
	in	a,($88)
	push	af		;Save value
	set	2,a		;Page video in
	out	($88),a
	ld	hl,32768
	ld	de,32769
	ld	bc,+(CONSOLE_ROWS * CONSOLE_COLUMNS * 8 ) 
	ld	(hl),0
	ldir
	; Now we point to start of colour memory
	; Consider KC85/2 first of all
	ld	bc,+(CONSOLE_ROWS * CONSOLE_COLUMNS * 2) -1
	ld	a,(kc_attr)
	ld	(hl),a
	ldir
	pop	af		;And restore paging
	out	($88),a
	ret

generic_console_scrollup:
	push	de
	push	bc
	in	a,($88)
	push	af
	set	2,a
	out	($88),a
	ld	bc, 0
loop:
	push	bc

	push	bc
	call	generic_console_xypos
	pop	bc
	push	hl	;save destination address
	inc	b	;row 1
	call	generic_console_xypos
	pop	de	;de = destination, hl = source row

	push	hl
	push	de
	ld	c,$20
	call	scroll_half
	pop	hl	;destination
	ld	bc,$20
	add	hl,bc
	ex	de,hl
	pop	hl
	add	hl,bc
	ld	c,$20
	call	scroll_half

	; Now do the RHS
	pop	bc
	push	bc		

	ld	c,32
	push	bc
	call	generic_console_xypos
	pop	bc
	push	hl	;Save destination address
	inc	b
	call	generic_console_xypos
	pop	de	;Get back destination address
	
	push	hl
	push	de
	ld	c,$08
	call	scroll_half
	pop	hl	;destination
	ld	bc,$20
	add	hl,bc
	ex	de,hl
	pop	hl
	add	hl,bc
	ld	c,$08
	call	scroll_half

	; Now do the colour attributes
	pop	bc
	push	bc

	;LHS
	push	bc
	call	cxypos
	pop	bc
	push	hl	;Save destination address
	inc	b
	call	cxypos
	pop	de	;Get back destination address

	ld	c,$20
	call	scroll_colour_half

	; Now do the RHS of the colour
	pop	bc
	push	bc
	ld	c,32
	push	bc
	call	cxypos
	pop	bc
	push	hl	;Save destination address
	inc	b
	call	cxypos
	pop	de	;Get back destination address

	ld	c,$08
	call	scroll_colour_half

	pop	bc
	inc	b
	ld	a,b
	cp	31
	jp	nz,loop
	pop	af
	out	($88),a
	pop	bc
	pop	de
	ret

; Scroll x number of rows (graphics)
; Entry: de = destination
;        hl = source
;         c = number of columns
;         b = number of rows
scroll_half:
	ld	b,4
scroll_half_loop:
	push	bc

	push	hl
	push	de
	ld	b,0
	ldir
	pop	hl		;dest
	ld	bc,128
	add	hl,bc	
	ex	de,hl
	pop	hl		;source
	add	hl,bc

	pop	bc
	djnz	scroll_half_loop
	ret

; Scroll x number of rows (colour)
; Entry: de = destination
;        hl = source
;         c = number of columns
;         b = number of rows
scroll_colour_half:
	ld	b,2
scroll_colour_half_loop:
	push	bc

	push	hl
	push	de
	ld	b,0
	ldir
	pop	hl		;dest
	ld	bc,32
	add	hl,bc	
	ex	de,hl
	pop	hl		;source
	add	hl,bc

	pop	bc
	djnz	scroll_colour_half_loop
	ret


; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
	; Here we can interpret any extra codes (eg for setting colours)
	ex	af,af
	in	a,($88)
	push	af
	set	2,a
	out	($88),a
	ex	af,af
        ld      l,d
        ld      h,0
        ld      de,(generic_console_font32)
        bit     7,l
        jr      z,not_udg
        res     7,l
        ld      de,(generic_console_udg32)
        inc     d
not_udg:
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,de
        dec     h
        ex      de,hl           ;de = font
	push	bc
	push	de
	call	generic_console_xypos
	pop	de
	push	hl
	ld	a,(generic_console_flags)
	rlca
	sbc	a,a
	ld	c,a		;c = 0 /255
	call	print_half
	pop	hl
	ld	a,l
	add	$20
	ld	l,a
	call	print_half

	; And now colour (again only KC82/2)
	pop	bc

	call	cxypos
	ld	de,$20
	ld	a,(kc_attr)
	ld	(hl),a
	add	hl,de
	ld	(hl),a
	pop	af
	out	($88),a
	ret

print_half:
        ld      b,4
hires_printc_1:
        ld      a,(de)
        xor     c
        ld      (hl),a
        inc     de
        ld      a,l
        add     $80
        ld      l,a
        jr      nc,no_overflow
        inc     h
no_overflow:
        djnz    hires_printc_1
	ret

; Colour generic_console_xypos
; Columns 0 - 31 = row * $40  $a8 base
; Columns 32 - 40 = for every 8 by $80, for each 2 rows increment by $8, if odd add $40 $b000 base

cxypos:
        ld      a,c
        sub     32
        jr      c,colour_lhs
        ld      c,a
        ld      a,b
        rrca
        rrca
        rrca
        and     @00000111
        ld      h,a
        ld      l,0
        srl     h               ;*80
        rr      l
        ld      a,b             ; (y / 2)  * 8
        rlca
        rlca
        and     @00011000
        add     c
        ld      c,a
        rr      b
        ld      b,$b0
        jr      nc,not_overflow
        add     $40
        ld      c,a
        jr      nc,not_overflow
        inc     b
not_overflow:
        add     hl,bc
        ret
colour_lhs:
        ld      h,b
        ld      l,0
        srl     h
        rr      l
        srl     h
        rr      l
        ld      b,$a8
        add     hl,bc
        ret
	




; $8000 base
; Columns 0 - 31 for every 8 by $800 For each 2 rows increment by $200, if the odd row add $40
; $a000
; Colums 32-40 for every 8 rows $200 for each 2 rows increment by $8, if odd add $40
generic_console_xypos:
	ld	a,c
        sub     32
        jr      c,lhs
        ld      c,a
        ld      a,b             ;per block of 8
        rrca
        rrca
        and     @00000110
        ld      h,a
        ld      l,0
        ld      a,b             ;per block of two
        rlca
        rlca
        and     @00011000
        bit     0,b
        jr      z,not_odd_rhs
        add     $40
not_odd_rhs:
        ld      l,a
        ld      b,$a0
        add     hl,bc
        ret

lhs:    ld      a,b             ;y
        and     @11111110       ;Disregard low bit
        ld      h,a
        ld      l,0
        bit     0,b
        jr      z,not_odd_lhs
        ld      l,$40
not_odd_lhs:
        ld      b,$80
        add     hl,bc
        ret

	SECTION	code_crt_init

	; Remove the cursor
	ld	hl,0xffff
	ld	(CURSO_COL),hl

		SECTION	data_clib
.kc_attr	defb @01111000
