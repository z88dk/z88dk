		; In code_driver so we are low down in memory and hopefully
		; never paged out
		SECTION		code_driver

		PUBLIC		generic_console_vpeek

		EXTERN		generic_console_font32
		EXTERN		generic_console_udg32

		EXTERN		l_push_di
		EXTERN		l_pop_ei

		EXTERN		__vram_in
		EXTERN		__vram_out
		EXTERN		__port29_copy
		EXTERN		__multi8_mode

                EXTERN		generic_console_xypos_graphics
                EXTERN		generic_console_xypos
                EXTERN		generic_console_scale
                EXTERN          screendollar
                EXTERN          screendollar_with_count


		defc		DISPLAY = 0x8000

;Entry: c = x,
;	b = y
;Exit:	nc = success
;	 a = character,
;	 c = failure
generic_console_vpeek:
	ld	a,(__multi8_mode)
	cp	2
	jr	z,vpeek_graphics
	call	generic_console_scale
	call	generic_console_xypos
	call	l_push_di
	ld	a,(__vram_in)
	out	($2a),a
	ld	b,(hl)
	ld	a,(__vram_out)
	out	($2a),a
	call	l_pop_ei
	ld	a,b
	and	a
	ret

vpeek_graphics:
        ld      hl,-8
        add     hl,sp           ;hl = buffer, bc = coords
        ld      sp,hl
        push    hl              ;Save buffer
	call	l_push_di

	push	hl
	call	generic_console_xypos_graphics	; hl = screen
	pop	de				; de = buffer

	ld	a,8
loop:
	push	af
	ld	a,(__vram_in)
	ld	b,a
	or	@00000110
	out	($2a),a
	ld	c,(hl)
	ld	a,b
	or	@00000101
	out	($2a),a
	ld	a,(hl)
	or	c
	ld	c,a
	ld	a,b
	or	@00000011
	out	($2a),a
	ld	a,(hl)
	or	c
	ld	(de),a
	inc	de
	ld	bc,80		;Move to next row
	add	hl,bc
	pop	af
	dec	a
	jr	nz,loop
	ld	a,(__vram_out)
	out	($2a),a
	call	l_pop_ei

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





