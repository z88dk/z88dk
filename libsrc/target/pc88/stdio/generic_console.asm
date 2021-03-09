

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute
		PUBLIC		generic_console_pointxy

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		asm_toupper
		EXTERN		l_push_di
		EXTERN		l_pop_ei
		EXTERN		__pc88_mode
		EXTERN		__pc88_ink
		EXTERN		__pc88_paper
		EXTERN		printc_MODE2
		EXTERN		scrollup_MODE2
		EXTERN		__pc88_attr
		EXTERN		generic_console_flags
		EXTERN		__console_x


		defc		DISPLAY = 0xf3c8



generic_console_set_paper:
	and	7
	ld	(__pc88_paper),a
	ret

generic_console_set_ink:
	and	7
	ld	(__pc88_ink),a
	rrca
	rrca
	rrca
	or	8	;colour specification
	ld	h,8
	ld	l,a
	call	set_attribute
	ret

generic_console_set_attribute:
	ld	hl,__pc88_attr
	ld	(hl),0
	ld	a,(generic_console_flags)
	bit	7,a
	jr	z,not_inverse
	set	2,(hl)
not_inverse:
	bit	3,a	;underline
	jr	z,not_underline
	set	5,(hl)
not_underline:
	bit	2,a
	jr	z,no_blink
	set	1,(hl)
no_blink:
	bit	4,a
	jr	z,not_bold
	set	4,(hl)
	set	5,(hl)
not_bold:
	ld	l,(hl)
	ld	h,0
	call	set_attribute
	ret

; Enter l = attribute to set
; h = 0: decoration, h = 8: colour
set_attribute:
	ld	bc,(__console_x)
set_attribute_at_position:
	in	a,($32)
	push	af
	res	4,a
	out	($32),a
	push	ix
	call	search_and_place_attribute
	pop	ix
	pop	af
	out	($32),a
	ret

search_and_place_attribute:
	push	bc
	call	xypos_attr_row	;ix = address
	pop	de		;e = x position
	ld	b,20		;number of decorators
loop:
	ld	a,(ix+0)
	cp	e
	jr	nz,check_empty
	; It's a coordinate at the same x position, lets check the type
	;We should increment the column regardless since we can't have
	;more than 1 attribute set at the same x coord
	inc	e
	ld	a,(ix+1)
	and	@00001000
	cp	h
	jr	nz,check_empty
	; It's an attribute at the right column and of the right type
	; lets overwrite it with our new value
	ld	(ix+1),l
	ret
check_empty:
	bit	7,(ix+0)
	jr	nz,got_free_slot
	inc	ix
	inc	ix
	djnz	loop
	ret
got_free_slot:
	ld	(ix+0),e	;X coordinate
	ld	(ix+1),l
	ret





	

generic_console_cls:
	ld	a,(__pc88_mode)
	and	a
	jr	z,clear_text
	; Clear the hires planes
	call	l_push_di
	out	($5e),a		;Switch to green
	call	clear_plane
	out	($5d),a		;Switch to red
	call	clear_plane
	out	($5c),a		;Switch to blue
	call	clear_plane
	out	($5f),a		;Back to main memory
	call	l_pop_ei

clear_text:
	in	a,($32)
	push	af
	res	4,a
	out	($32),a
	; Clearing for text
	ld	hl, DISPLAY
	ld	c,25
cls_1:
	ld	b,80
cls_2:
	ld	(hl),' '
	inc	hl
	djnz	cls_2
	call	clear_row_attribute
	dec	c
	jr	nz,cls_1
	pop	af
	out	($32),a
	ret


clear_row_attribute:
	ld	b,20		;20 attributes
	ld	d,0
	ld	a,(__pc88_ink)
	cp	7
	jr	z,no_set_colour
	ld	(hl),d	;Column
	inc	d
	inc	hl
	rrca
	rrca
	rrca
	or	8
	ld	(hl),a
	inc	hl
	dec	b
no_set_colour:
	ld	a,(__pc88_attr)
	and	a
	jr	z,no_set_decoration
	ld	(hl),d
	inc	hl
	ld	(hl),a
	inc	hl
	dec	b
no_set_decoration:
	ld	(hl),0x80
	inc	hl
	ld	(hl),0xe8
	inc	hl
	djnz	no_set_decoration
	ret


clear_plane:
	ld	hl,$c000
	ld	de,$c001
	ld	bc,15999	;80x200 - 1
	ld	(hl),0
	ldir
	ret


; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
	ld	a,(__pc88_mode)
	cp	2
	jp	z,printc_MODE2
	push	de
	call	generic_console_scale
	call	xypos
not_40_col:
	pop	de	;d = character to write
	in	a,($32)
	ld	e,a
	res	4,a
	out	($32),a
	ld	(hl),d
	ld	a,e
	out	($32),a
	ret


generic_console_pointxy:
	call	generic_console_vpeek
	and	a
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	call	generic_console_scale
        call    xypos
	in	a,($32)
	ld	c,a
	res	4,a
	out	($32),a

	ld	d,(hl)

	ld	a,c
	out	($32),a
	ld	a,d
	and	a
	ret


generic_console_scale:
        push    af
        ld      a,(__pc88_mode)
        cp      1
        jr      nz,no_scale
        sla     c               ;40 -> 80 column
no_scale:
        pop     af
        ret

; b = y
; c = x (scaled to 80 columns)
xypos_attr_row:
	ld	ix,DISPLAY-40
	ld	de,120
	inc	b
xypos_attr_1:
	add	ix,de
	djnz	xypos_attr_1
	ret


xypos:
	ld	hl,DISPLAY - 120
	ld	de,120
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	ret



generic_console_scrollup:
	push	de
	push	bc
	ld	a,(__pc88_mode)
	cp	2
	jp	z,scrollup_MODE2
	in	a,($32)
	push	af
	res	4,a
	out	($32),a
	ld	hl, DISPLAY + 120
	ld	de, DISPLAY
	ld	bc, 120 * 24
	ldir
	ex	de,hl
	ld	b,80
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	inc	hl
	call	clear_row_attribute
	pop	af
	out	($32),a
	pop	bc
	pop	de
	ret

	SECTION 	code_crt_init

	EXTERN	pc88_cursoroff

	call	pc88_cursoroff
	ld	hl,$E6B9
	res	1,(hl)
	ld	a,($E6C0)
	set	1,a
	ld	($E6C0),a
	out	($30),a
