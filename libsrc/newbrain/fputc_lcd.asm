;
; Grundy Newbrain Specific libraries
;
; Stefano Bodrato - 30/03/2007
;
;
; Print a character on LCD display
;
;
;
; $Id: fputc_lcd.asm,v 1.3 2007-06-03 15:13:06 stefano Exp $
;


	XLIB fputc_lcd

.fputc_lcd
	ld	hl,2
	add	hl,sp
	ld	e,(hl)	; char
	inc	hl
	inc	hl
	
	ld	a,(hl)
	cp	16
	ret	nc

	ld	a,77
	sub	(hl)	; pos 0..15
	ld	l,a
	ld	h,0
	ld	a,e
	ld	(hl),a
	ret
