;
;
; 	ANSI Video handling for the VZ200
;
;
; 	Clean a text line
;
;	Stefano Bodrato - Apr. 2000
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;


	XLIB	ansi_del_line


.ansi_del_line
	ret
	ld	hl,$7000
.sum_loop
	ld	de,32
	add	hl,de
	dec	a
	jr	nz,sum_loop

	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,31
	ldir
	ret
