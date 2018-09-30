		SECTION		code_driver

		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_pointxy

		EXTERN		generic_console_font32
		EXTERN		generic_console_udg32
		EXTERN		lynx_lores_graphics

                EXTERN          screendollar
                EXTERN          screendollar_no_inverse
                EXTERN          screendollar_with_count

		INCLUDE		"target/lynx/def/lynx.def"

generic_console_pointxy:
        ld      hl,-8
        add     hl,sp           ;hl = buffer, bc = coords
        ld      sp,hl
        push    hl              ;Save buffer
	call	read_screen
	pop	de
	ld	hl,(lynx_lores_graphics)
	ld	a,h	
	or	l
	scf
	jr	z,gotit
	call	screendollar_no_inverse
	jr	gotit


;Entry: c = x,
;	b = y
;Exit:	nc = success
;	 a = character,
;	 c = failure
generic_console_vpeek:
        ld      hl,-8
        add     hl,sp           ;hl = buffer, bc = coords
        ld      sp,hl
        push    hl              ;Save buffer
	call	read_screen
	pop	de		;de = buffer of stack
	ld	hl,(generic_console_font32)
	call	screendollar
	jr	nc,gotit
	ld	hl,(generic_console_udg32)
	ld	b,128
	call	screendollar_with_count
	jr	c,gotit
	add	128
gotit:
	ex	af,af
	ld	hl,8
	add	hl,sp
	ld	sp,hl
	ex	af,af
	ret




read_screen:
	ex	de,hl		;de = buffer
        ld      h,b             ;y * 256
        ld      l,0
        ld      b,$a0		;alt green page
        add     hl,bc           ;Add x (Address in graphics page)
	ld	b,8
vpeek_loop:
	push	bc
	push	hl
	push	de
	call	INGREEN
	pop	de
	ld	a,l
	ld	(de),a
	inc	de
	pop	hl
	ld	bc,32
	add	hl,bc
	pop	bc
	djnz	vpeek_loop
	ret
