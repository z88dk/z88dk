;
; 	ANSI Video handling
;	Non optimized (but generic) code
;
; 	Clean a text line
;
;	Stefano Bodrato - 2014
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.5 2016-04-04 18:31:22 dom Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_del_line

	EXTERN	ansi_ROW
	EXTERN	ansi_COLUMN

	EXTERN	text_cols

	EXTERN	ansi_CHAR

.ansi_del_line

	ld	e,a
	ld	a,(ansi_ROW)
	push af
	
	ld	a,e
	ld  (ansi_ROW),a

	ld	a,(text_cols)
	ld  b,a

.rloop
	ld	a,b
	dec a
	ld  (ansi_COLUMN),a
	push bc
	ld   a,' '
	call ansi_CHAR
	pop  bc
	djnz rloop

	pop	af
	ld  (ansi_ROW),a
	
	ret
