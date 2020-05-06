

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

	EXTERN	__special_attr
	EXTERN	__specialmx_attr
	EXTERN	conio_map_colour
	EXTERN	conio_map_colour_mx
	EXTERN	CONSOLE_COLUMNS
	EXTERN	CONSOLE_ROWS

	defc	DISPLAY = $9000


; Write to $fff8 with the colour (SpecialMX)
; Write to $ff02 with the colour (Special with board)

generic_console_set_attribute:
        ret

generic_console_set_ink:
	ld	d,a	;Save it, we'll need it
	call	set_ink_mx
	ld	a,d
	call	conio_map_colour
	ld	(__special_attr),a
	ret


generic_console_set_paper:
	call	conio_map_colour_mx
	and	15
	ld	b,a
	ld	c,$f0
set_attr:
	ld	hl,__specialmx_attr
	ld	a,(hl)
	and	c
	or	b
	ld	(hl),a
	ret

set_ink_mx:
	call	conio_map_colour_mx
	rlca
	rlca
	rlca
	rlca
	and	$f0
	ld	b,a
	ld	c,$0f
	jp	set_attr

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
	call	setup_attr
	ld	hl,DISPLAY
	ld	de,DISPLAY+1
	ld	bc,+(((CONSOLE_COLUMNS * CONSOLE_ROWS) * 8)-1)
	ld	(hl),0
	ldir
	ret

setup_attr:
	ld	a,(__special_attr)
	ld	($ff02),a
;	ld	a,(__specialmx_attr)
;	ld	($fff8),a
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

	call	setup_attr
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
