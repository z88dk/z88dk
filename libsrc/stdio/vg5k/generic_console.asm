

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		defc		DISPLAY = 0x4000

generic_console_ioctl:
	scf
generic_console_set_inverse:
	ret

generic_console_set_paper:
	jp	generic_console_set_ink
	and	7
	rlca
	rlca
	rlca
	rlca
	ld	c,a
	ld	hl,vg5k_attr
	ld	a,(hl)
	and	@10001111
	or	c
	ld	(hl),a
	ret


generic_console_set_ink:
	and	7
	ld	c,a
	ld	hl,vg5k_attr
	ld	a,(hl)
	and	@11111000
	or	c
	ld	(hl),a
	ret

generic_console_cls:
	ld	c,CONSOLE_ROWS
	ld	hl, DISPLAY
	ld	a,(vg5k_attr)
	and	7
cls0:
	ld	b,CONSOLE_COLUMNS 
cls1:	ld	(hl),32
	inc	hl
	ld	(hl),a
	inc	hl
	djnz	cls1
	dec	c
	jr	nz,cls0
	set	0,(iy+1)		;iy -> ix, trigger interrupt to redraw screen
	ld	(iy+0),1		;force an immediate redraw
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	push	bc	;save coordinates
	push	de
	ld	hl,DISPLAY - 80
	ld	de,80
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	ld	d,a			;Save character
	ld	a,(vg5k_attr)
	add	hl,bc		
	add	hl,bc			;hl now points to address in display
	ld	(hl),d			;place character
	inc	hl
	pop	bc			;get raw mode back into e
	rr	c
	jr	nc,is_gfx
	or	128
is_gfx:
	ld	(hl),a
	pop	hl			;get coordinates back
	ld	e,a			;attribute
	ld	a,h
	and	a
	jr	z,zrow
	add	7
	ld	h,a
zrow:
	call	0x0092			;call the rom to do the hardwork
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	hl, DISPLAY + 80
	ld	de, DISPLAY
	ld	bc, 80 * (CONSOLE_ROWS-1)
	ldir
	ex	de,hl
	ld	a,(vg5k_attr)
	and	7
	ld	b,CONSOLE_COLUMNS
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	ld	(hl),a
	inc	hl
	djnz	generic_console_scrollup_3
	set	0,(iy+1)		;iy -> ix, trigger interrupt to redraw screen
	ld	(iy+0),1		;force an immediate redraw
	pop	bc
	pop	de
	ret


	SECTION		data_clib

vg5k_attr:	defb	7	;White on black
