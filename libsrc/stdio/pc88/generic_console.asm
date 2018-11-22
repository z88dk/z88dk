

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse
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
generic_console_set_inverse:
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
	; Clearing for text
	ld	hl, DISPLAY
	ld	de,120
	ld	c,25
cls_1:
	push	hl
	ld	b,80
cls_2:
	ld	(hl),' '
	inc	hl
	djnz	cls_2
	ld	b,40
cls_3:
	ld	(hl),0
	inc	hl
	djnz	cls_3
	pop	hl
	add	hl,de
	dec	c
	jr	nz,cls_1
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
	ld	(hl),d
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
	ld	a,(hl)
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
	pop	bc
	pop	de
	ret

	SECTION 	code_crt_init

	EXTERN	pc88_cursoroff

	call	pc88_cursoroff
