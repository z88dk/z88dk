;
; 	ANSI Video handling for the Commodore 128 (Z80 mode)
;	By Stefano Bodrato - 22/08/2001
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.1 2001-08-28 14:05:43 stefano Exp $
;

	XLIB	ansi_SCROLLUP


.ansi_SCROLLUP

	ld	bc,$d011
	in	a,(c)
	or	7
	out	(c),a
	
	ld	hl,$400+(40*24)
	ld	b,40
.reslloop
	ld	(hl),32
	inc	hl
	djnz	reslloop

	ret

