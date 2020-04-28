

	MODULE	generic_console
        SECTION code_clib

	PUBLIC	generic_console_cls
	PUBLIC	generic_console_set_attribute
	PUBLIC	generic_console_set_ink
	PUBLIC	generic_console_set_paper
	PUBLIC	generic_console_printc
	PUBLIC	generic_console_scrollup
	PUBLIC	generic_console_xypos

        EXTERN  generic_console_font32
        EXTERN  generic_console_udg32

        EXTERN  generic_console_flags

	EXTERN	CONSOLE_COLUMNS
	EXTERN	CONSOLE_ROWS

	defc	DISPLAY = $9000


generic_console_set_attribute:
generic_console_set_ink:
generic_console_set_paper:
        ret

generic_console_scrollup:
	push	de
	push	bc
	ld	de,DISPLAY
	ld	hl,DISPLAY + 8

	ld	c,248
scrollup_1:
	push	hl
	push	de
	ld	b,48
row_loop:
	ld	a,(hl)
	ld	(de),a
	inc	h
	inc	d
	dec	b
	jp	nz,row_loop
	pop	de
	pop	hl
	inc	l
	inc	e
	dec	c
	jp	nz,scrollup_1
	ld	a,48
	ld	b,31
	ld	c,0
clear_loop:
	push	af
	push	bc
	ld	a,' '
	ld	d,a
	ld	e,0
	call	generic_console_printc
	pop	bc
	inc	c
	pop	af
	dec	a
	jp	nz,clear_loop
	pop	bc
	pop	de
	ret


generic_console_cls:
	ld	hl,DISPLAY
	ld	de,DISPLAY+1
	ld	bc,+(((CONSOLE_COLUMNS * CONSOLE_ROWS) * 8)-1)
	ld	(hl),0
	ldir
	ret

; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
        ld      e,d
        ld      d,0
        ld      a,e
        ld      hl,(generic_console_font32)
        rlca
        jr      nc,not_udg
        ld      a,e
        and     127
        ld      e,a
        ld      hl,(generic_console_udg32)
        inc     h               ;We decrement later
not_udg:
        ex      de,hl
        add     hl,hl
        add     hl,hl
        add     hl,hl
	dec	h
        add     hl,de
	ex	de,hl			;de = font
	call	generic_console_xypos	;-> hl = screen
	ex	de,hl

        ld      a,(generic_console_flags)
        rlca
        sbc     a
        ld      c,a             ;c = 0 / c = 255
        ld      b,8
printc_hires_loop:
        push    bc

        ld      a,b
        cp      1
        jr      nz,no_need_for_underline
        ld      a,(generic_console_flags)
        and     @00001000
        jr      z,no_need_for_underline
        ld      a,255
        jr      not_bold
no_need_for_underline:
        ld      a,(generic_console_flags)
        and     @00010000
        ld      a,(hl)
        jr      z,not_bold
        rrca
        or      (hl)
not_bold:
        xor     c               ;Add in inverse
	ld	(de),a
	inc	e
	inc	hl
	pop	bc
	dec	b
	jp	nz,printc_hires_loop
        ret


; Entry:
; c = x
; b = y
; Exit:
; hl = screen address
generic_console_xypos:
	ld	a,+(DISPLAY /256)
	add	c
	ld	h,a
	ld	a,b
	add	a
	add	a
	add	a
	ld	l,a
	ret
