

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


		defc		DISPLAY = 0xf3c8



generic_console_set_paper:
	and	7
	ld	(__pc88_paper),a
	ret

generic_console_set_ink:
	and	7
	ld	(__pc88_ink),a
generic_console_set_attribute:
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
	ld	b,20
cls_3:
	ld	(hl),0
	inc	hl
	ld	(hl),0
	inc	hl
	djnz	cls_3
	dec	c
	jr	nz,cls_1
	pop	af
	out	($32),a
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
	pop	de
	in	a,($32)
	ld	e,a
	res	4,a
	out	($32),a
	ld	(hl),d
	; TODO: Attribute
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
	ld	b,40
scroll_2:
	ld	(hl),0
	inc	hl
	djnz	scroll_2
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
