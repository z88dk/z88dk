;
; 	ANSI Video handling for the Sharp X1
;
; 	Clean a text line
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.6 2016-06-10 23:47:18 dom Exp $
;


        SECTION code_clib
	PUBLIC	ansi_del_line
	EXTERN	text_cols
	EXTERN	ATTR


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
