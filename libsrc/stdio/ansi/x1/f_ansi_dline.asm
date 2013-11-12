;
; 	ANSI Video handling for the Sharp X1
;
; 	Clean a text line
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.3 2013-11-12 13:50:15 stefano Exp $
;


	XLIB	ansi_del_line
	XREF	text_cols


.ansi_del_line
	ld	hl,$3000
	and	a
	jr	z,isz
	push af
	ld	a,(text_cols)
	ld	d,l
	ld	e,a
	pop af
.sum_loop
	add	hl,de
	dec	a
	jr	nz,sum_loop
.isz
	dec	e
	ld	b,e
	;ld	b,39
.dlineloop
	ld	a,32
	ld	b,h
	ld	c,l
	out (c),a
	;ld	(hl),32
	inc	hl
	djnz	dlineloop
	ret
