;
; 	ANSI Video handling for the Commodore 128 (Z80 mode)
;	By Stefano Bodrato - 22/08/2001
;
; 	CLS - Clear the screen
;	
;
;	$Id: f_ansi_cls.asm,v 1.1 2001-08-28 14:05:43 stefano Exp $
;

	XLIB	ansi_cls

.ansi_cls
	ld	hl,$400
	ld	bc,1023
.clsloop
	ld	(hl),32
	inc	hl
	dec	bc
	ld	a,b
	or	c
	jr	nz,clsloop
	ret
