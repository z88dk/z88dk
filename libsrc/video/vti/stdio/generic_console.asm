; Generic console/graphics driver for the VTI S100 board

		SECTION		code_clib

		PUBLIC		generic_console_cls
		PUBLIC		generic_console_vpeek
		PUBLIC		generic_console_printc
		PUBLIC		generic_console_scrollup
		PUBLIC		generic_console_ioctl
                PUBLIC          generic_console_set_ink
                PUBLIC          generic_console_set_paper
                PUBLIC          generic_console_set_attribute
                PUBLIC          generic_console_plotc
                PUBLIC          generic_console_pointxy
                EXTERN		generic_console_flags

		EXTERN		COLUMNS
		EXTERN		ROWS
		
		EXTERN		VTI_DISPLAY

		defc		COLUMNS = 64
		defc		ROWS = 16

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
	ld	hl,VTI_DISPLAY
	ld	de,VTI_DISPLAY+1
	ld	bc,+(COLUMNS * ROWS) -1
	ld	(hl),32 + 0x80
	ldir
	ret


; c = x
; b = y
; a = d = character to print
; e = raw
generic_console_plotc:
	call	xypos
	ld	(hl),d
	ret

generic_console_printc:
	call	xypos
	ld	a,e	;raw
	rrca
	ld	a,d
	jr	c,place	;it's raw, just place the character 
	or	128	;Regular ascii characters have bit 7 set
place:
	ld	(hl),a
	ret

;Entry: c = x,
;       b = y
;       e = rawmode
;Exit:  nc = success
;        a = character,
;        c = failure
generic_console_pointxy:
        call    xypos
	ld	a,(hl)
	rlca
	ret	c	;An ascii character was place, so this will treat it as blank
	rrca
	and	63	;Back to the graphics
	ret

generic_console_vpeek:
        call    xypos
	ld	a,(hl)
	and	127
	ret


; b = row
; c = column
xypos:
	ld	l,b
	ld	h,0
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	add	hl,hl
	ld	b,+(VTI_DISPLAY / 256)
	add	hl,bc
	ret


generic_console_scrollup:
	push	de
	push	bc
	ld	hl, VTI_DISPLAY + COLUMNS
	ld	de, VTI_DISPLAY
	ld	bc,+ ((COLUMNS) * (ROWS-1))
	ldir
	ex	de,hl
	ld	b,COLUMNS
generic_console_scrollup_3:
	ld	(hl),32 + 0x80
	inc	hl
	djnz	generic_console_scrollup_3
	pop	bc
	pop	de
	ret



	SECTION	code_crt_init
	; Set the size of the console to this hardware
	EXTERN	__console_w
	EXTERN	__console_h

	ld	a,COLUMNS
	ld	(__console_w),a
	ld	a,ROWS
	ld	(__console_h),a
