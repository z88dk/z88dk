

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

	defc	DISPLAY = $c000


generic_console_set_attribute:
generic_console_set_ink:
generic_console_set_paper:
        ret

generic_console_scrollup:
	push	de
	push	bc
	ld	de,DISPLAY
	ld	hl,DISPLAY + 256
	ld	bc,+(((CONSOLE_COLUMNS * (CONSOLE_ROWS-1)) * 8)-1)
	ldir
	ex	de,hl
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,255
	ld	(hl),0
	ldir
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
        ld      de,(generic_console_font32)
        dec     d
        bit     7,a
        jr      z,printc_rejoin
        ld      de,(generic_console_udg32)
        res     7,a
printc_rejoin:
        ld      l,a
        ld      h,0
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,de
	ex	de,hl			;de = font
	call	generic_console_xypos	;-> hl = screen

        ld      a,(generic_console_flags)
        rlca
        sbc     a
        ld      c,a             ;c = 0 / c = 255
        ld      b,8
printc_hires_loop:
        push    bc
	ld	a,(generic_console_flags)
	bit	4,a		;Bold
        ld      a,(de)
	jr	z,not_bold
	ld	b,a
	rrca
	or	b
not_bold:
        xor     c
	; Display is mirrored bits, need to switch round
	ld	c,a
        rlca
        rlca
        xor     c
        and     0xaa
        xor     c
        ld      c,a
        rlca
        rlca
        rlca
        rrc     c
        xor     c
        and     0x66
        xor     c
	ld	(hl),a
	ld	bc,32
	add	hl,bc
	inc	de
	pop	bc
	djnz	printc_hires_loop
	; And deal with underline
	ld	a,(generic_console_flags)
	bit	3,a
	ret	z
	ld	bc,-32
	add	hl,bc
	ld	(hl),255
        ret


; Entry:
; c = x
; b = y
; Exit:
; hl = screen address
generic_console_xypos:
	ld	h,b	;*8 * 32
	ld	l,c
	ld	a,+(DISPLAY/256)
	add	h
	ld	h,a
	ret
