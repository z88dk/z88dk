;
; 	ANSI Video handling
;	Non optimized (but generic) code
;
; 	CLS - Clear the screen
;	
;
;	Stefano Bodrato - 2014
;
;
;	$Id: f_ansi_cls.asm,v 1.1 2014-07-16 09:59:57 stefano Exp $
;

	XLIB	ansi_cls

	LIB		ansi_del_line

	XREF	text_rows

.ansi_cls
	ld a,(text_rows)
	ld b,a

.clsloop
	push bc
	ld	a,b
	dec a
	call	ansi_del_line
	pop bc
	djnz clsloop

	ret
