;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 22/05/2007
;
;
; Print a string on LCD display
;
;
;
; $Id: fputs_lcd.asm,v 1.2 2007-06-07 08:23:09 stefano Exp $
;


	XLIB fputs_lcd

	LIB ZCALL


.fputs_lcd
	pop	bc
	pop	hl
	push	hl
	push	bc

	ld	de,77
	ld	b,15
.sloop
	ld	a,(hl)
	and	a
	ret	z
	
	ld	(de),a
	inc	hl
	dec	de
	djnz	sloop

	ret
