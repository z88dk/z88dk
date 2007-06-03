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
; $Id: fputs_lcd.asm,v 1.1 2007-06-03 15:13:06 stefano Exp $
;


	XLIB fputs_lcd

	LIB ZCALL


.fputs_lcd
	pop	bc
	pop	hl
	push	hl
	push	bc
.fplcd
	ld	a,(hl)
	and	a
	jr	z,endstr
	ld	e,4
	call	ZCALL
	defb	$30	; ZOUTPUT
	inc	hl
	jr	fplcd
.endstr
	ld	a,$28	; send a final leftmargin
	call	ZCALL
	defb	$30	; ZOUTPUT
	ret
