;
;
; The Nascom has a strange screen 
;
; Video memory starts at 0x800 and is 0x400 bytes long
;
; The top row is actually row 16
; The video memory is 64 bytes per row
; - But display starts at offset 10 and is 48 characters
;

		SECTION		code_clib

		PUBLIC		generic_console_printc

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS

		defc		DISPLAY = 0x080a
		defc		TOPROW = DISPLAY + (CONSOLE_ROWS - 1) * 64

; c = x
; b = y
; a = d character to print
; e = raw
generic_console_printc:
	ld	hl,TOPROW
	ld	a,b
	and	a
	ld	a,d
	jr	z,generic_console_printc_3
	ld	hl, DISPLAY - 64
	ld	de,64
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	ld	(hl),a
	ret
