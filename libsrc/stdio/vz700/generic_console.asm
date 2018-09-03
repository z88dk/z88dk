

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_inverse

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		defc		DISPLAY = 0x7000

generic_console_ioctl:
	scf
generic_console_set_inverse:
	ret

generic_console_set_paper:
	and	7
	ld	b,a
	ld	a,(attr)
	and	0xf0
	or	b
	ld	(attr),a
	ret

generic_console_set_ink:
	and	7
	rlca
	rlca
	rlca
	rlca
	ld	b,a
	ld	a,(attr)
	and	0x0f
	or	b
	ld	(attr),a
	ret

	

generic_console_cls:
	ld	hl, DISPLAY
	ld	bc, 2032 / 2
	ld	de,(attr)
	ld	d,32
loop:
	ld	(hl),d
	inc	hl
	ld	(hl),e
	inc	hl
	dec	bc	
	ld	a,b
	or	c
	jr	nz,loop
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	call	xypos
	ld	(hl),a
	inc	hl
	ld	a,(attr)
	ld	(hl),a
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        call    xypos
	ld	a,(hl)
	and	a
	ret


xypos:
	push	af
	ld	a,b		; Modulus 8 * 256
	and	7
	ld	h,a
	ld	l,0
	srl	b		;/ 8
	srl	b
	srl	b
	ld	de,80
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	add	hl,bc			;hl now points to address in display
	ld	bc,DISPLAY
	add	hl,bc
	pop	af
	ret



generic_console_scrollup:
	push	de
	push	bc
	; Awkward screen layout
	pop	bc
	pop	de
	ret

	SECTION	bss_clib

attr:	defb	0x07
