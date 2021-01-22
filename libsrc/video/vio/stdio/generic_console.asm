; Generic console/graphics driver for the VIO IMSAI board

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

		EXTERN		COLUMNS
		EXTERN		ROWS
		
		EXTERN		VIO_DISPLAY

		defc		COLUMNS = 80
		defc		ROWS = 24

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
	ld	hl,VIO_DISPLAY
	ld	de,VIO_DISPLAY+1
	ld	bc,+(COLUMNS * ROWS) -1
	ld	(hl),32 
	ldir
	ret


; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_printc:
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
	ld	l,b
	ld	h,0
	add	hl,hl	;*2
	add	hl,hl	;*4
	add	hl,hl	;*8
	add	hl,hl	;*16
	ld	e,l
	ld	d,h
	add	hl,hl	;*32
	add	hl,hl	;*64
	add	hl,de
	ld	b,+(VIO_DISPLAY / 256)
	add	hl,bc
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	hl, VIO_DISPLAY + COLUMNS
	ld	de, VIO_DISPLAY
	ld	bc,+ ((COLUMNS) * (ROWS-1))
	ldir
	ex	de,hl
	ld	b,COLUMNS
generic_console_scrollup_3:
	ld	(hl),32
	inc	hl
	djnz	generic_console_scrollup_3
	pop	bc
	pop	de
	ret



	SECTION	code_crt_init
	; Set the size of the console to this hardware
	EXTERN	__console_w
	EXTERN	__console_h

	ld	a,%00001100		;Show characters 0 - 0xff, 80 columns, 24 rows
	ld	($f7ff),a
	ld	a,80
	ld	(__console_w),a
	ld	a,24
	ld	(__console_h),a
