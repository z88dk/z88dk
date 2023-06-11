;
;


		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_printc
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		EXTERN		conio_map_colour
		EXTERN		__c128_attr
		EXTERN		__c128_paper

		defc		DISPLAY = $2000
		defc		COLOUR_MAP = $1000


generic_console_set_attribute:
	ret

generic_console_set_ink:
	call	conio_map_colour
	and	15
	ld	(__c128_attr),a
	ret

	
generic_console_set_paper:
	call	conio_map_colour
	and	15
	ld	(__c128_paper),a
	ret

generic_console_cls:
	ld	hl, DISPLAY
	ld	de, DISPLAY +1
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	(hl),32
	ldir
	ld	hl, COLOUR_MAP
	ld	de, COLOUR_MAP+1
	ld	bc, +(CONSOLE_COLUMNS * CONSOLE_ROWS) - 1
	ld	a,(__c128_attr)
	ld	(hl),a
	ldir
	ld	bc,$D021
	ld	a,(__c128_paper)
	out (c),a
	ld	bc,$D020	; BORDER
	out (c),a
	ret

; c = x
; b = y
; a = character to print
; e = raw
generic_console_printc:
	call	xypos
	ld	(hl),a
	ld	a,h
	sub	16
	ld	h,a
	ld	a,(__c128_attr)
	ld	(hl),a
	ret


;Entry: c = x,
;       b = y
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        call    xypos
        ld      a,(hl)
        and     a
        ret


xypos:
	ld	hl,DISPLAY - CONSOLE_COLUMNS
	ld	de,CONSOLE_COLUMNS
	inc	b
generic_console_printc_1:
	add	hl,de
	djnz	generic_console_printc_1
generic_console_printc_3:
	add	hl,bc			;hl now points to address in display
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	hl, DISPLAY + CONSOLE_COLUMNS
	ld	de, DISPLAY
	ld	bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	ld	hl, COLOUR_MAP + CONSOLE_COLUMNS
	ld	de, COLOUR_MAP
	ld	bc,+ ((CONSOLE_COLUMNS) * (CONSOLE_ROWS-1))
	ldir
	ex	de,hl
	ld	b,CONSOLE_COLUMNS
	ld	a,(__c128_attr)
generic_console_scrollup_4:
	ld	(hl),a
	inc	hl
	djnz	generic_console_scrollup_4
	pop	bc
	pop	de
	ret


	SECTION	code_crt_init
	EXTERN	CRT_FONT

	ld	hl,CRT_FONT
	ld	a,h
	or	l
	jr	z,no_set_font
	ld	a,$8c	;Character generator to $3000
	ld	bc,$d018
	out	(c),a
	ld	de,$3100
	ld	bc,768
	ldir
no_set_font:

