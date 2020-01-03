
		MODULE	generic_console_vpeek
		SECTION	code_clib
		PUBLIC	generic_console_vpeek

                EXTERN          generic_console_font32
                EXTERN          generic_console_udg32
                EXTERN          screendollar
                EXTERN          screendollar_with_count
                EXTERN          generic_console_xypos_graphics

generic_console_vpeek:
        ld      hl,-8
        add     hl,sp           ;hl = buffer, bc = coords
        ld      sp,hl
	push	hl		;Save buffer
        push    hl              ;Save buffer
	call	generic_console_xypos_graphics	;hl = screen
	pop	de		; de = buffer

	ld	a,8
loop:
	push	af
	ld	a,1
	out	($f1),a
	ld	c,(hl)
	ld	a,2
	out	($f1),a
	ld	a,(hl)
	or	c
	ld	c,a
	ld	a,3
	out	($f1),a
	ld	a,(hl)
	or	c
	ld	bc,(generic_console_font32)
	bit	5,b
	jr	z,rom_font
        ld      c,a
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
rom_font:
	ld	(de),a
	inc	de
	ld	bc,24
	add	hl,bc
	pop	af
	dec	a
	jr	nz,loop
	pop	de	;de = buffer on stack
        ld      hl,(generic_console_font32)
        call    screendollar
        jr      nc,gotit
        ld      hl,(generic_console_udg32)
        ld      b,128
        call    screendollar_with_count
        jr      c,gotit
        add     128
gotit:
        ex      af,af
        ld      hl,8
        add     hl,sp
        ld      sp,hl
        ex      af,af
        ret
