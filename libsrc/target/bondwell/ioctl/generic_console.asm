;


		SECTION		code_graphics

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		
		PUBLIC		generic_console_set_ink
		PUBLIC		generic_console_set_paper
		PUBLIC		generic_console_set_attribute
		
		EXTERN		generic_console_xypos
		EXTERN		swapgfxbk
		EXTERN		swapgfxbk1
		EXTERN		cleargraphics

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		defc		pagein = swapgfxbk
		defc		pageout = swapgfxbk1
		defc		DISPLAY = 0xF800



generic_console_set_attribute:
generic_console_set_ink:
generic_console_set_paper:
	ret


generic_console_cls:
	call	pagein
	call	cleargraphics
	call	pageout
	ret


; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	call	pagein
	call	generic_console_xypos
	ld	(hl),a
	call	pageout
	ret


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
	call	pagein
	call    generic_console_xypos
	ld      a,(hl)
	and     a
	call	pageout
	ret



	SECTION	code_crt_init

        EXTERN  asm_set_cursor_state

        ld      l,$20
        call    asm_set_cursor_state
