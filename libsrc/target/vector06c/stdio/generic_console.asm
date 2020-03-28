

                SECTION         code_clib

                PUBLIC          generic_console_cls
                PUBLIC          generic_console_printc
                PUBLIC          generic_console_scrollup
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute
		PUBLIC		generic_console_xypos


                EXTERN          CONSOLE_COLUMNS
                EXTERN          CONSOLE_ROWS

                EXTERN          generic_console_font32
                EXTERN          generic_console_udg32
		EXTERN		generic_console_flags
		EXTERN		conio_map_colour
		EXTERN		__vector06c_ink
		EXTERN		__vector06c_paper
		EXTERN		__vector06c_scroll



generic_console_set_paper:
	and	15
	ld	(__vector06c_paper),a
	ret

generic_console_set_attribute:
	ret


generic_console_set_ink:
	and	15
	ld	(__vector06c_ink),a
	ret


generic_console_scrollup:
	push	bc
	push	de
	ld	a,(__vector06c_scroll)
	sub	8
	ld	(__vector06c_scroll),a
	out	(3),a
	ld	b,CONSOLE_ROWS-1
	ld	c,0
scrollup_1:
	push	bc
	ld	d,' '
	call	generic_console_printc
	pop	bc
	inc	c
	ld	a,c
	cp	32
	jr	nz,scrollup_1
	pop	de
	pop	bc
	ret

generic_console_cls:
	ld	hl,65535
	ld	b,4
	ld	a,(__vector06c_paper)
	ld	d,a
loop1:
	ld	a,d
	rrca
	ld	d,a
	sbc	a
	ld	e,a
	push	bc
	push	de
	ld	bc,8192
loop2:
	ld	(hl),e
	dec	hl
	dec	bc
	ld	a,b
	or	c
	jp	nz,loop2
	pop	de
	pop	bc
	dec	b
	jp	nz,loop1
	ret

generic_console_printc:
        ld      e,d
        ld      d,0
        ld      a,e
        ld      hl,(generic_console_font32)
        rlca
        jr      nc,not_udg
	ld	a,e
	and	127
	ld	e,a
        ld      hl,(generic_console_udg32)
        inc     h               ;We decrement later
not_udg:
        ex      de,hl
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,de
        dec     h               ; -32 characters
        ex      de,hl           ; de = font
	call	generic_console_xypos	;hl = screen
	ex	de,hl

	;hl = font, de = screen

	; Setup inverse flag
	ld	a,(generic_console_flags)
	rlca
	sbc	a
	ld	c,a
	ld	b,8
printc_1:
	push	bc
	push	hl
	push	de	;Screen address

	ld	a,b
	cp	1
	jr	nz,no_need_for_underline
	ld	a,(generic_console_flags)
	and	@00001000
	jr	z,no_need_for_underline
	ld	a,255
	jr	not_bold
no_need_for_underline:
	ld	a,(generic_console_flags)
	and	@00010000
	ld	a,(hl)
	jr	z,not_bold
	rrca
	or	(hl)
not_bold:
	xor	c		;Add in inverse
	ld	b,a		;The pixel row to print

	ld	hl,(__vector06c_ink)
	; consider bit 0
	ld	a,l	;ink
	rrca
	ld	l,a
	sbc	a
	ld	e,a
	ld	a,b
	and	e
	ld	e,a
	ld	a,h	;paper
	rrca
	ld	h,a
	sbc	a
	ld	d,a	;The required bit for the paper
	ld	a,b
	cpl		;Select the paper bits
	and	d
	or	e	;This is now the required bits for this bitplane
	pop	de
	ld	(de),a
	ld	a,d
	sub	$20	;Step to next plane
	ld	d,a
	push	de

	; And now onto plane 1
        ld      a,l     ;ink
        rrca
	ld	l,a
        sbc     a
        ld      e,a
        ld      a,b
        and     e
        ld      e,a
        ld      a,h     ;paper
        rrca
	ld	h,a
        sbc     a
        ld      d,a     ;The required bit for the paper
        ld      a,b
	cpl
        and     d
        or      e       ;This is now the required bits for this bitplane
        pop     de
        ld      (de),a
        ld      a,d
        sub	$20     ;Step to next plane
        ld      d,a
        push    de

	;Plane 2
        ld      a,l     ;ink
        rrca
	ld	l,a
        sbc     a
        ld      e,a
        ld      a,b
        and     e
        ld      e,a
        ld      a,h     ;paper
        rrca
	ld	h,a
        sbc     a
        ld      d,a     ;The required bit for the paper
        ld      a,b
	cpl
        and     d
        or      e       ;This is now the required bits for this bitplane
        pop     de
        ld      (de),a
        ld      a,d
        sub	$20     ;Step to next plane
        ld      d,a
        push    de

	;Plane 3
        ld      a,l     ;ink
        rrca
        sbc     a
        ld      e,a
        ld      a,b
        and     e
        ld      e,a
        ld      a,h     ;paper
        rrca
        sbc     a
        ld      d,a     ;The required bit for the paper
        ld      a,b
	cpl
        and     d
        or      e       ;This is now the required bits for this bitplane
        pop     de
        ld      (de),a
	; Go back to first place and step to next row
	ld	a,$60
	add	d
	ld	d,a
	dec	e	;Next row

	pop	hl	;font
	inc	hl
	pop	bc	;loop + inverse
	djnz	printc_1
	ret




	
	



; Entry: b = row
;	 c = column
; Exit:	hl = address (in plane 0)
generic_console_xypos:
	; Each column is 256 bytes, rows count from bottom
	ld	a,$E0
	add	c
	ld	h,a
	ld	a,b
	add	a
	add	a
	add	a
	cpl
	inc	a
	ld	l,a
	ld	a,(__vector06c_scroll)
	add	l
	ld	l,a
	ret



