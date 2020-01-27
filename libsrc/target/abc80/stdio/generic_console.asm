;

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		defc		DISPLAY = 31744

		PUBLIC          CLIB_GENCON_CAPS
		defc            CLIB_GENCON_CAPS = 0

generic_console_ioctl:
	scf
generic_console_set_ink:
generic_console_set_paper:
generic_console_set_attribute:
	ret

generic_console_cls:
        ld      hl,884          ; ROW table in ROM
	ld	c,CONSOLE_ROWS
cls_1:
	ld	e,(hl)
	inc	hl
	ld	d,(hl)
	inc	hl
	ld	b,CONSOLE_COLUMNS
	ld	a,32
cls_2:
	ld	(de),a
	inc	de
	djnz	cls_2
	dec	c
	jr	nz,cls_1
	ret


; c = x
; b = y
; a = d character to print
; e = raw
generic_console_printc:
	push	af
	call	xypos
	pop	af
	ld	(hl),a
	ret

;Entry: c = x,
;	b = y
;Exit:	nc = success
;	 a = character,
;	 c = failure
generic_console_vpeek:
	call	xypos
	ld	a,(hl)
	and	a
	ret

xypos:
	ld	a,b
        ld      hl,884          ; ROW table in ROM
        ld      d,0
        rla
        ld      e,a
        add     hl,de
        ld      a,(hl)
        inc     hl
        ld      h,(hl)
        ld      l,a
	ld	b,0
	add	hl,bc
	ret


IF NOTROM
	ld	a,b
        ld      hl,31744        ; OLD method (non ROM dependent)
        cp      8
        jr      c,jpvdu
        ld      hl,31784
        sub     8
        cp      8
        jr      c,jpvdu
        ld      hl,31824
        sub     8
.jpvdu
        and     a
        jr      z,r_zero
        ld      b,a
        ld      de,128
.r_loop
        add     hl,de
        djnz    r_loop
	add	hl,bc
	ret
ENDIF

generic_console_scrollup:
	push	de
	push	bc
	ld	a,23
	ld	bc,0
generic_console_scrollup_1:
	push	af
	push	bc

	push	bc		;save coordinates
	call	xypos		;destination
	ex	de,hl
	pop	bc		;coordinates back
	push	de		;save dest
	inc	b
	call	xypos
	pop	de		;dest back
	ld	bc,40		;and copy
	ldir

	pop	bc
	pop	af
	inc	b
	dec	a
	jr	nz,generic_console_scrollup_1

	ld	bc, 23 * 256	;last row
	call	xypos
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,CONSOLE_COLUMNS-1
	ld	(hl),32
	ldir

	pop	bc
	pop	de

	ret

