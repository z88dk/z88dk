

                SECTION         code_clib

                PUBLIC          generic_console_cls
                PUBLIC          generic_console_printc
                PUBLIC          generic_console_scrollup
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute
		PUBLIC		generic_console_xypos


                EXTERN          CONSOLE_COLUMNS
                EXTERN          CONSOLE_ROWS

                ;EXTERN          generic_console_font32
                ;EXTERN          generic_console_udg32
		;EXTERN		generic_console_flags
		;EXTERN		conio_map_colour


generic_console_set_paper:
generic_console_set_attribute:
	ret


generic_console_set_ink:
	ret

generic_console_scrollup:
	push bc
	push de
	ld	bc,$0808
	call generic_console_xypos
	ld	a,13
	rst $20
	ld	a,10
	rst $20
	pop de
	pop bc
	ret
  
generic_console_cls:
	ld	a,12
	rst $20
	ret


; c = x
; b = y
; a = d character to print
; e = raw
generic_console_printc:
	call generic_console_xypos
	ld	a,d
	rst $20
	ret


; Entry: b = row
;	 c = column
; Exit:	hl = address
generic_console_xypos:
	ld	a,c
	inc a
	ld	($f63a),a	; CSRY
	ld	a,b
	inc a
	ld	($f639),a	; CSRX
	ret

