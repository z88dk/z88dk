;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Apr. 2000
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

	XLIB	ansi_SCROLLUP
	LIB	ansi_del_line


.ansi_SCROLLUP
	ld	hl,(16396)
	inc	hl
	inc	hl
	ld	d,h
	ld	e,l
	ld	bc,33
	add	hl,bc
	ld	bc,33*23
	ldir
	ld	a,23
	call	ansi_del_line
	ret
