

                SECTION         code_clib

                PUBLIC          generic_console_cls
                PUBLIC          generic_console_printc
                PUBLIC          generic_console_scrollup
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute


                EXTERN          CONSOLE_COLUMNS
                EXTERN          CONSOLE_ROWS

                EXTERN          generic_console_font32
                EXTERN          generic_console_udg32
		EXTERN		generic_console_flags

                defc		DISPLAY = $d800




generic_console_set_paper:
generic_console_set_attribute:
generic_console_set_ink:
	ret


generic_console_scrollup:
	push	bc
	push	de

	pop	de
	pop	bc
	ret

generic_console_cls:
        ld      hl,DISPLAY
        ld      de,DISPLAY+1
        ld      bc,$2800 -1
        ld      (hl),0
        ldir
        ret

; b = row
; c = column
; a = d = character
generic_console_printc:
        ld      e,d
        ld      d,0
        ld      a,e
        ld      hl,(generic_console_font32)
        rlca
        jr      nc,not_udg
	ld	a,e
	and	127
	ld	e,a
        ld      hl,(generic_console_udg32)
        inc     h               ;We decrement later
not_udg:
        ex      de,hl
        add     hl,hl
        add     hl,hl
        add     hl,hl
        add     hl,de
        dec     h               ; -32 characters


        ; Calculate screen address
        ld      a,c
        cpl
        ld      d,a
        ld      a,b
	add	a
	add	a
	add	a
        cpl
        ld      e,a


	;hl = font, de = screen

	; Setup inverse flag
	ld	a,(generic_console_flags)
	rlca
	sbc	a
	ld	c,a
	ld	b,8
printc_1:
	ld	a,b
	cp	1
	jr	nz,no_need_for_underline
	ld	a,(generic_console_flags)
	and	@00001000
	jr	z,no_need_for_underline
	ld	a,255
	jr	not_bold
no_need_for_underline:
	ld	a,(generic_console_flags)
	and	@00010000
	ld	a,(hl)
	jr	z,not_bold
	rrca
	or	(hl)
not_bold:
	xor	c		;Add in inverse
        ld      (de),a
        rlc     e
        dec     e
        rrc     e
	inc	hl
	djnz	printc_1
	ret
