;
; 	ANSI Video handling
;	Non optimized (but generic) code
;
; 	Clean a text line
;
;	Stefano Bodrato - 8/5
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

	XLIB	ansi_del_line

	LIB	ansi_CHAR

	XREF	text_cols
	XREF	ansi_COLUMN
	XREF	ansi_ROW

	ld	a,(ansi_ROW)
	ld	b,a
	push	bc
	ld	(ansi_ROW),a
.ansi_del_line
	ld	a,(text_cols)
	dec	a
.eclloop
	ld	(ansi_COLUMN),a
        push    af
        ld      a,32 ;' '   ; BLANK
        call    ansi_CHAR   ; The low level video routine
        pop     af
	dec	a
        cp      0
        jp      p,eclloop
	pop	bc
	ld	a,b
	ld	(ansi_ROW),a
        ret
