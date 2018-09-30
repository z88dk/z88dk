;
;



		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		__x1_attr

		defc		DISPLAY = $3000

generic_console_ioctl:
	scf
	ret

generic_console_set_inverse:
	ld	a,(__x1_attr)
	res	3,a
	bit	7,(hl)
	jr	z,not_inverse
	set	3,a
not_inverse:
	ld	(__x1_attr),a
	ret

generic_console_set_ink:
	and	7
	ld	e,a
	ld	a,(__x1_attr)
	and	@11111000
	or	e
	ld	(__x1_attr),a
	ret

	
generic_console_set_paper:
	ret

generic_console_cls:
        ld      bc,DISPLAY
        ld      hl, CONSOLE_ROWS * CONSOLE_COLUMNS
cls_1:
        ld      a,' '
        out     (c),a
	res	4,b
        ld      a,(__x1_attr)
        out     (c),a
	set	4,b
        inc     bc
        dec     hl
        ld      a,h
        or      l
        jr      nz,cls_1
        ret


; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	call	xypos
	ld	c,l
	ld	b,h
	out	(c),a
	res	4,b
	ld	a,(__x1_attr)
	out	(c),a
	ret


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        call    xypos
	ld	c,l
	ld	b,h
	in	a,(c)
        and     a
        ret


xypos:
	ld	hl,DISPLAY - CONSOLE_COLUMNS
	ld	de,CONSOLE_COLUMNS
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
        ld      bc, DISPLAY + CONSOLE_COLUMNS     ;source
        ld      hl, +((CONSOLE_ROWS -1)* CONSOLE_COLUMNS)
scroll_loop:
        push    hl
        in      e,(c)
        res	4,b
        in      d,(c)
        set	4,b
        ld      hl,-CONSOLE_COLUMNS
        add     hl,bc
        ld      c,l
        ld      b,h
        out     (c),e
        res	4,b
        out     (c),d
        set	4,b
        ld      hl,CONSOLE_COLUMNS + 1
        add     hl,bc
        ld      c,l
        ld      b,h
        pop     hl
        dec     hl
        ld      a,h
        or      l
        jr      nz,scroll_loop

        ld      hl,-CONSOLE_COLUMNS
        add     hl,bc
        ld      c,l
        ld      b,h
        ld      e,CONSOLE_COLUMNS
        ld      d,' '
        ld      a,(__x1_attr)
scroll_loop_2:
        out     (c),d
        res	4,b
        out     (c),a
        set	4,b
        inc     bc
        dec     e
        jr      nz,scroll_loop_2
        pop     bc
        pop     de
        ret

