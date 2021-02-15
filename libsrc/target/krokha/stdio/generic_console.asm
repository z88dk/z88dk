; Generic console driver for the Krokha ("tiny")

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute
                EXTERN		generic_console_flags

		EXTERN		asm_toupper

		EXTERN		CONSOLE_COLUMNS
		EXTERN		CONSOLE_ROWS
		
		defc		DISPLAY = $ea00

		INCLUDE	"ioctl.def"
	        PUBLIC  CLIB_GENCON_CAPS
		defc	CLIB_GENCON_CAPS = 0

generic_console_ioctl:
	scf
generic_console_set_ink:
generic_console_set_paper:
generic_console_set_attribute:
	ret

generic_console_cls:
	ld	hl,DISPLAY
	ld	bc,+(CONSOLE_COLUMNS * CONSOLE_ROWS)
cls_1:
	ld	(hl),32
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jp	nz,cls_1
	ret


; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
	ld	a,e
	and	a
	jp	nz,rawmode
	ld	a,d
	call	asm_toupper
	ld	d,a
rawmode:
	ld	a,d
	call	xypos	;Preserves a
	ld	(hl),a
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_vpeek:
        call    xypos
	ld	a,(hl)
	and	a
	ret


; b = row
; c = column
xypos:
	ld	l,c
	ld	h,0
	add	hl,hl	;*2
	add	hl,hl	;*4
	add	hl,hl	;*8
	add	hl,hl	;*16
	add	hl,hl	;*32
	ld	c,b
	ld	b,+(DISPLAY / 256)
	add	hl,bc
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	hl, DISPLAY + 1
	ld	de, DISPLAY
	ld	bc,+(CONSOLE_COLUMNS*(CONSOLE_ROWS-1))-1
scroll1:
	ld	a,(hl)
	ld	(de),a
	inc	de
	inc	hl	
	dec	bc
	ld	a,b
	or	c
	jp	nz,scroll1

	ld	b,CONSOLE_ROWS-1
	ld	c,0
	call	xypos
	ld	b,CONSOLE_COLUMNS
clear1:
	ld	(hl),32
	ld	de,CONSOLE_ROWS
	add	hl,de
	dec	b
	jp	nz,clear1
	pop	bc
	pop	de
	ret
