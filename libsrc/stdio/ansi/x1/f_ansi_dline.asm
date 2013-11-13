;
; 	ANSI Video handling for the Sharp X1
;
; 	Clean a text line
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.4 2013-11-13 11:04:54 stefano Exp $
;


	XLIB	ansi_del_line
	XREF	text_cols
	XREF	ATTR


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
	push bc
	ld	b,h
	ld	c,l
	ld	a,32
	out (c),a
        res 4, b
        ld	a,(ATTR+1)
        out (c), a
	inc	hl
	pop bc
	djnz	dlineloop
	ret
