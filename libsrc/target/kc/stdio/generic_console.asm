; VEB MPM KC Driver
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
                PUBLIC          generic_console_set_attribute
		PUBLIC		generic_console_xypos
		PUBLIC		kc_attr
		PUBLIC		kc_type

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
generic_console_set_attribute:
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
	ld	a,(iy+1)	;port 84
	res	1,a
	ld	(iy+1),a
	out	($84),a		;pixels
	ld	hl,32768
	ld	de,32769
	ld	bc,+(CONSOLE_ROWS * CONSOLE_COLUMNS * 8 ) 
	ld	(hl),0
	ldir
	ld	a,(kc_type)
	and	a
	jr	z,clear_attributes_kc85_2_3
	ld	a,(iy+1)	;port 84
	set	1,a
	ld	(iy+1),a
	out	($84),a		;pixels
        ld      hl,32768
        ld      de,32769
        ld      bc,+(CONSOLE_ROWS * CONSOLE_COLUMNS * 8 )
	ld	a,(kc_attr)
        ld      (hl),a
        ldir
	jr	cls_rejoin
clear_attributes_kc85_2_3:
	; Now we point to start of colour memory
	; Consider KC85/2 first of all
	ld	bc,+(CONSOLE_ROWS * CONSOLE_COLUMNS * 2) 
	ld	a,(kc_attr)
	ld	(hl),a
	ldir
cls_rejoin:
	pop	af		;And restore paging
	out	($88),a
	ret

scrollup_85_4:
	ld	b,CONSOLE_COLUMNS
	ld	hl,$8008
	ld	de,$8000
scrollup_85_4_1:
	push	bc
	push	hl
	push	de
	ld	a,(iy+1)
	res	1,a
	ld	(iy+1),a
	out	($84),a
	ld	bc,248
	ldir
	set	1,a
	ld	(iy+1),a
	out	($84),a
	pop	de
	pop	hl
	push	hl
	push	de
        ld      bc,248
	ldir
	pop	de
	pop	hl
	inc	d
	inc	h
	pop	bc
	djnz	scrollup_85_4_1
	; Now blank some characters
	ld	bc, + (CONSOLE_ROWS - 1) * 256
	jp	print_blank_row



generic_console_scrollup:
	push	de
	push	bc
	in	a,($88)
	push	af
	set	2,a
	out	($88),a
	ld	a,(kc_type)
	and	a
	jr	nz,scrollup_85_4
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

print_blank_row:
	; And now blank out the bottom row - print a space
	ld	a,40
blank_row:
	push	af
	ld	a,' '
	ld	d,a
	ld	e,0
	push	bc
	call	generic_console_printc
	pop	bc
	inc	c
	pop	af
	dec	a
	jr	nz,blank_row

	pop	af
	out	($88),a
scrollup_done:
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
	ld	a,(kc_type)
	and	a
	jr	nz,printc_kc85_4
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

	; And now colour (again only KC85/2)
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

; Print to a kc85_4 screen
; de = font
; bc = xypos
; On stack, old value for port 88
printc_kc85_4:
	ld	a,(iy+1)	;iy = ix, this is port 0x84 copy
	res	1,a
	ld	(iy+1),a
	out	($84),a
	call	xypos_85_4
	push	hl		;Save address
	ld	a,(generic_console_flags)
	rlca
	sbc	a,a
	ld	c,a		;c = 0 /255
	ld	b,8
printc_kc85_4_1:
	ld	a,(de)
	xor	c
	ld	(hl),a
	inc	de
	inc	l
	djnz	printc_kc85_4_1
	; Now, do the attributes
	pop	hl		;address back
	ld	a,(iy+1)	;iy = ix, this is port 0x84 copy
	set	1,a		;select attributes
	ld	(iy+1),a
	out	($84),a
	ld	b,8
	ld	a,(kc_attr)
printc_kc85_4_2:
	ld	(hl),a
	inc	l	
	djnz	printc_kc85_4_2
        pop     af
        out     ($88),a
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
	

; Entry: b = row
;        c = column
; Exit: hl = address
xypos_85_4:
	Ld	a,c
	add	$80
	ld	h,a
	ld	a,b
	add	a
	add	a
	add	a
	ld	l,a
	ret



; $8000 base
; Columns 0 - 31 for every 8 by $800 For each 2 rows increment by $200, if the odd row add $40
; $a000
; Colums 32-40 for every 8 rows $200 for each 2 rows increment by $8, if odd add $40
generic_console_xypos:
	ld	a,(kc_type)
	and	a
	jr	nz,xypos_85_4
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
        ; initialize the kc_attr
        ld      a,@01111000    ; white on black
        ld      (kc_attr),a
        ; check for <= 85/3 oder >= 85/4
	ld	hl,$0001
	call	PV1
	defb	FNPADR
	ld	l,0
	ld	a,h
	cp	$81
	jr	nz,crt_init_not_kc85_4
	inc	l
	ld	a,(iy+1)
	res	0,a	;display image 0
	res	2,a	;cpu access 0
	set	3,a	;disable hicolor
	ld	(iy+1),a
	out	($84),a
crt_init_not_kc85_4:
	ld	a,l
	ld	(kc_type),a


        SECTION code_crt_exit
        ld      a,(kc_type)
        and     a
        jr      z,crt_exit_not_kc85_4
        ; 85/4 needs to switch back to pixel memory  
        ld      a,(iy+1)
        res     1,a     ;access to pixel memory
        ld      (iy+1),a
        out     ($84),a
crt_exit_not_kc85_4:
        ld      a,$39   ; CAOS default color: white on blue
        ld      (COLOR),a

		SECTION bss_clib

.kc_type	defb	0		;holds 1 for >= KC85/4

		SECTION	data_clib
.kc_attr	defb @01111000
