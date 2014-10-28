;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Sept. 2007
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.6 2014-10-28 21:07:08 stefano Exp $
;

	XLIB	ansi_SCROLLUP
	LIB	ansi_del_line
	XREF	base_graphics
	XREF	text_rows


.ansi_SCROLLUP
	ld	hl,(base_graphics)
IF G007
	push hl
	ld	de,272
	add	hl,de
	pop de
ELSE
 IF MTHRG
	push hl
	ld	de,264
	add	hl,de
	pop de
 ELSE
	ld	d,h
	ld	e,l
	inc	h
 ENDIF
ENDIF

IF G007
	ld bc,272*23-1
ELSE
 IF MTHRG
	ld bc,264*24-1
 ELSE
	ld	a,(text_rows)
	ld	b,a
	ld	c,0
	dec	b
 ENDIF
ENDIF
	;ld	bc,6144-256
	ldir
	ld	a,(text_rows)
	dec	a
	call	ansi_del_line
	ret
