;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Apr. 2000
;
; 	CLS - Clear the screen
;	
;
;	$Id: f_ansi_cls.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

	XLIB	ansi_cls

.ansi_cls

        ld	hl,(16396)
	ld	a,118
	ld	(hl),a
	ld	c,24
.drow
	inc	hl
	ld	b,32
	ld	a,128
.dcol	ld	(hl),a
	inc	hl
	djnz	dcol
	ld	a,118
	ld	(hl),a
	dec	c
	jr	nz,drow
	ret
