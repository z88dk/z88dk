;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Sept. 2007
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.3 2007-10-03 15:11:39 stefano Exp $
;

	XLIB	ansi_SCROLLUP
	LIB	ansi_del_line
	XREF	base_graphics
	XREF	text_rows


.ansi_SCROLLUP
	ld	hl,(base_graphics)
	ld	d,h
	ld	e,l
	inc	h
	ld	bc,6144-256
	ldir
	ld	a,(text_rows)
	dec	a
	call	ansi_del_line
	ret
