


	;hl = font


	; Setup inverse flag
	ld	a,(generic_console_flags)
	rlca
	sbc	a
	ld	c,a


	ld	b,8
printc_1:
	push	bc
	push	de	;Screen address

	ld	a,b
	cp	1
	jr	nz,no_need_for_underline
	ld	a,(generic_console_flags)
	ld	b,a
	and	@00001000
	jr	z,no_need_for_underline
	ld	a,255
	jr	not_bold
no_need_for_underline:
	ld	a,b		;Flags
	and	@00010000
	ld	a,(hl)
	jr	z,not_bold
	ld	b,a
	rrca
	or	b
not_bold:
	xor	c		;Add in inverse
	ld	b,a		;The pixel row to print

	push	hl
	ld	hl,(__vector6_ink)

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
	add	$20	;Step to next plane
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
        add     $20     ;Step to next plane
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
        add     $20     ;Step to next plane
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
	ld	a,-$60
	add	d
	ld	d,a
	inc	e	;Next row

	pop	hl	;font
	inc	hl
	pop	bc	;loop + inverse
	djnz	printc_1






	
	
