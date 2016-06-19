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
; $Id: fputs_lcd.asm,v 1.4 2016-06-19 20:33:40 dom Exp $
;

        SECTION code_clib
	PUBLIC fputs_lcd
	PUBLIC _fputs_lcd

	EXTERN ZCALL


.fputs_lcd
._fputs_lcd
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
