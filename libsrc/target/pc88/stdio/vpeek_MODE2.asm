	; In code_driver so we are low down in memory and hopefully
	; never paged out
	SECTION	code_driver

	PUBLIC	vpeek_MODE2

	EXTERN	generic_console_font32
	EXTERN	generic_console_udg32

	EXTERN	l_push_di
	EXTERN	l_pop_ei

        EXTERN	generic_console_xypos_graphics
        EXTERN  screendollar
        EXTERN  screendollar_with_count
	
	INCLUDE	"target/pc88/def/pc88.def"


;Entry: c = x,
;	b = y
;Exit:	nc = success
;	 a = character,
;	 c = failure
vpeek_MODE2:
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
	xor	a
	out	(GVRAM_SEL_0),a		;Switch to blue
	or	(hl)
	out	(GVRAM_SEL_1),a		;Switch to green
	or	(hl)
	out	(GVRAM_SEL_2),a		;Switch to red
	or	(hl)
	out	(MAINRAM_SEL),a		;Switch to main
	ld	(de),a
	inc	de
	ld	bc,80			;Move to next row
	add	hl,bc
	pop	af
	dec	a
	jr	nz,loop
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





