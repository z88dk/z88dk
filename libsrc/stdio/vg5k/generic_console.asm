

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
cls0:
	ld	(hl),0x00
	inc	hl
	ld	a,(vg5k_attr)
	ld	(hl),a
	inc	hl
	and	7
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
	push	de
	ld	hl,DISPLAY - 80
	ld	de,80
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
;	ld	(hl),0x00
	inc	hl			;Skip first two bytes - define background colour
	ld	e,a			;Save character
	ld	a,(vg5k_attr)
;	ld	(hl),a			;Set colour
	inc	hl
	add	hl,bc			;hl now points to address in display
	add	hl,bc			;hl now points to address in display
	ld	(hl),e			;place character
	inc	hl
	pop	de			;get raw mode back into e
	rr	e
	jr	c,is_gfx
	and	7
is_gfx:
	ld	(hl),a
	set	0,(iy+1)		;iy -> ix, trigger interrupt to redraw screen
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	hl, DISPLAY + 80
	ld	de, DISPLAY
	ld	bc, 80 * (CONSOLE_ROWS-1)
	ldir
	ex	de,hl
	ld	(hl),0x00
	inc	hl
	ld	a,(vg5k_attr)
	ld	(hl),a
	and	7
	inc	hl
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

vg5k_attr:		defb	128+7	;White on black
